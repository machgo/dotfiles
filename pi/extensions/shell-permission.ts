import {
	isToolCallEventType,
	type ExtensionAPI,
	type ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { realpath, stat } from "node:fs/promises";
import { basename, dirname, isAbsolute, relative, resolve, sep } from "node:path";

const ALLOW_ONCE = "Allow once";
const ALLOW_EXACT = "Allow this exact command for this session";
const DENY = "Deny";
const PATH_TOOL_NAMES = new Set(["read", "write", "edit", "grep", "find", "ls"]);

async function canonicalPath(rawPath: string, cwd: string): Promise<string> {
	// Built-in path tools also normalize a leading @.
	const target = resolve(cwd, rawPath.startsWith("@") ? rawPath.slice(1) : rawPath);

	try {
		return await realpath(target);
	} catch {
		// New files cannot be resolved directly. Resolve their nearest existing
		// parent so an existing symlink cannot disguise an external destination.
		let existing = target;
		const missingParts: string[] = [];
		while (dirname(existing) !== existing) {
			missingParts.unshift(basename(existing));
			existing = dirname(existing);
			try {
				return resolve(await realpath(existing), ...missingParts);
			} catch {
				// Keep walking toward the filesystem root.
			}
		}
		return target;
	}
}

function isWithin(parent: string, target: string): boolean {
	const child = relative(parent, target);
	return child === "" || (!isAbsolute(child) && child !== ".." && !child.startsWith(`..${sep}`));
}

async function permissionDirectory(target: string): Promise<string> {
	try {
		return (await stat(target)).isDirectory() ? target : dirname(target);
	} catch {
		return dirname(target);
	}
}

/**
 * Returns the executable name only for a single, simple shell command.
 * Compound commands and commands containing shell expansion are deliberately
 * excluded so allowing `git` cannot also approve `git status && rm -rf ...`.
 */
function simpleExecutable(command: string): string | undefined {
	const trimmed = command.trim();
	if (!trimmed || /[\n\r;&|<>`$(){}\\]/.test(trimmed)) return undefined;

	const firstWord = trimmed.match(/^(?:"([^"]+)"|'([^']+)'|([^\s]+))/);
	const executable = firstWord?.[1] ?? firstWord?.[2] ?? firstWord?.[3];
	if (!executable || executable.includes("=")) return undefined;

	return basename(executable);
}

export default function shellPermission(pi: ExtensionAPI) {
	const allowedExecutables = new Set<string>();
	const allowedExactCommands = new Set<string>();
	const allowedExactPaths = new Set<string>();
	const allowedDirectories = new Set<string>();

	async function approve(command: string, ctx: ExtensionContext): Promise<boolean> {
		if (allowedExactCommands.has(command)) return true;

		const executable = simpleExecutable(command);
		if (executable && allowedExecutables.has(executable)) return true;

		// Fail closed in print/JSON mode, where pi cannot ask the user.
		if (!ctx.hasUI) return false;

		const allowExecutable = executable
			? `Allow “${executable}” for this session (all arguments)`
			: undefined;
		const choices = [ALLOW_ONCE, ALLOW_EXACT];
		if (allowExecutable) choices.push(allowExecutable);
		choices.push(DENY);

		const choice = await ctx.ui.select(
			`Shell command requested:\n\n${command}\n\nRun it?`,
			choices,
		);

		if (choice === ALLOW_ONCE) return true;
		if (choice === ALLOW_EXACT) {
			allowedExactCommands.add(command);
			return true;
		}
		if (allowExecutable && choice === allowExecutable) {
			allowedExecutables.add(executable!);
			ctx.ui.notify(`Allowed ${executable} commands for this session`, "warning");
			return true;
		}

		return false;
	}

	async function approveExternalPath(
		rawPath: string,
		operation: string,
		ctx: ExtensionContext,
	): Promise<boolean> {
		const cwd = await canonicalPath(ctx.cwd, ctx.cwd);
		const target = await canonicalPath(rawPath, ctx.cwd);
		if (isWithin(cwd, target)) return true;
		if (allowedExactPaths.has(target)) return true;
		if ([...allowedDirectories].some((directory) => isWithin(directory, target))) return true;
		if (!ctx.hasUI) return false;

		const directory = await permissionDirectory(target);
		const allowPath = "Allow this exact path for this session";
		const allowDirectory = `Allow directory “${directory}” for this session`;
		const choice = await ctx.ui.select(
			`External file access requested (${operation}):\n\n${target}\n\nAllow it?`,
			[ALLOW_ONCE, allowPath, allowDirectory, DENY],
		);

		if (choice === ALLOW_ONCE) return true;
		if (choice === allowPath) {
			allowedExactPaths.add(target);
			return true;
		}
		if (choice === allowDirectory) {
			allowedDirectories.add(directory);
			ctx.ui.notify(`Allowed external directory ${directory} for this session`, "warning");
			return true;
		}
		return false;
	}

	// Gate shell commands requested by the model through the built-in bash tool.
	pi.on("tool_call", async (event, ctx) => {
		if (!isToolCallEventType("bash", event)) return;

		if (!(await approve(event.input.command, ctx))) {
			return {
				block: true,
				reason: ctx.hasUI
					? "Shell command denied by user"
					: "Shell command blocked because no confirmation UI is available",
			};
		}
	});

	// Gate every built-in tool that accepts a filesystem path. Relative paths
	// resolving inside cwd continue without a prompt.
	pi.on("tool_call", async (event, ctx) => {
		if (!PATH_TOOL_NAMES.has(event.toolName)) return;
		const rawPath = (event.input as { path?: unknown }).path;
		if (typeof rawPath !== "string") return;

		if (!(await approveExternalPath(rawPath, event.toolName, ctx))) {
			return {
				block: true,
				reason: ctx.hasUI
					? "External file access denied by user"
					: "External file access blocked because no confirmation UI is available",
			};
		}
	});

	// Gate commands entered with pi's ! and !! shortcuts as well.
	pi.on("user_bash", async (event, ctx) => {
		if (await approve(event.command, ctx)) return;

		return {
			result: {
				output: ctx.hasUI
					? "Shell command denied by user"
					: "Shell command blocked because no confirmation UI is available",
				exitCode: 126,
				cancelled: false,
				truncated: false,
			},
		};
	});

	pi.registerCommand("shell-allow", {
		description: "Allow a simple executable for this session (example: /shell-allow git)",
		handler: async (args, ctx) => {
			const executable = args.trim();
			if (!/^[A-Za-z0-9_.+-]+$/.test(executable)) {
				ctx.ui.notify("Usage: /shell-allow <executable>, for example /shell-allow git", "error");
				return;
			}
			allowedExecutables.add(executable);
			ctx.ui.notify(`Allowed ${executable} commands for this session`, "warning");
		},
	});

	pi.registerCommand("shell-permissions", {
		description: "Show shell permissions granted during this session",
		handler: async (_args, ctx) => {
			const executables = [...allowedExecutables].sort();
			ctx.ui.notify(
				`Allowed executables: ${executables.join(", ") || "none"}\nAllowed exact commands: ${allowedExactCommands.size}`,
				"info",
			);
		},
	});

	pi.registerCommand("shell-permissions-clear", {
		description: "Revoke all shell permissions granted during this session",
		handler: async (_args, ctx) => {
			allowedExecutables.clear();
			allowedExactCommands.clear();
			ctx.ui.notify("Cleared all shell permissions", "info");
		},
	});

	pi.registerCommand("file-allow", {
		description: "Allow an external file or directory for this session",
		handler: async (args, ctx) => {
			if (!args.trim()) {
				ctx.ui.notify("Usage: /file-allow <path>", "error");
				return;
			}
			const target = await canonicalPath(args.trim(), ctx.cwd);
			try {
				if ((await stat(target)).isDirectory()) allowedDirectories.add(target);
				else allowedExactPaths.add(target);
			} catch {
				allowedExactPaths.add(target);
			}
			ctx.ui.notify(`Allowed external path ${target} for this session`, "warning");
		},
	});

	pi.registerCommand("file-permissions", {
		description: "Show external filesystem permissions granted during this session",
		handler: async (_args, ctx) => {
			ctx.ui.notify(
				`Allowed directories: ${[...allowedDirectories].sort().join(", ") || "none"}\nAllowed exact paths: ${[...allowedExactPaths].sort().join(", ") || "none"}`,
				"info",
			);
		},
	});

	pi.registerCommand("file-permissions-clear", {
		description: "Revoke all external filesystem permissions granted during this session",
		handler: async (_args, ctx) => {
			allowedDirectories.clear();
			allowedExactPaths.clear();
			ctx.ui.notify("Cleared all external filesystem permissions", "info");
		},
	});
}
