import {
	isToolCallEventType,
	type ExtensionAPI,
	type ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { realpath } from "node:fs/promises";
import { basename, dirname, isAbsolute, relative, resolve, sep } from "node:path";

const ALLOW_ONCE = "Allow once";
const DENY = "Deny";
const ALWAYS_ALLOWED_EXECUTABLES = new Set(["find", "git", "rg"]);
const PATH_TOOL_NAMES = new Set(["write", "edit"]);

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

/**
 * Returns the executables in a conservative shell command list. Lists joined
 * with `;`, newlines, `&&`, or `||` are supported, but pipelines, redirects,
 * command substitutions, background jobs, and shell groups are rejected.
 * This lets `git status && git diff` use the git whitelist without allowing
 * `git status && rm -rf ...`.
 */
function simpleExecutables(command: string): string[] | undefined {
	const segments: string[] = [];
	let segmentStart = 0;
	let quote: "'" | '"' | undefined;
	let escaped = false;

	for (let index = 0; index < command.length; index++) {
		const character = command[index];

		if (escaped) {
			escaped = false;
			continue;
		}
		if (character === "\\" && quote !== "'") {
			escaped = true;
			continue;
		}
		if (quote) {
			if (character === quote) quote = undefined;
			else if (quote === '"' && (character === "`" || (character === "$" && command[index + 1] === "("))) {
				return undefined;
			}
			continue;
		}
		if (character === "'" || character === '"') {
			quote = character;
			continue;
		}
		if (character === "`" || (character === "$" && command[index + 1] === "(")) return undefined;
		if (/[<>(){}]/.test(character)) return undefined;

		let separatorLength = 0;
		if (character === ";" || character === "\n" || character === "\r") separatorLength = 1;
		else if ((character === "&" || character === "|") && command[index + 1] === character) {
			separatorLength = 2;
		} else if (character === "&" || character === "|") {
			return undefined;
		}

		if (separatorLength) {
			const segment = command.slice(segmentStart, index).trim();
			if (!segment) return undefined;
			segments.push(segment);
			index += separatorLength - 1;
			segmentStart = index + 1;
		}
	}

	if (quote || escaped) return undefined;
	const finalSegment = command.slice(segmentStart).trim();
	if (finalSegment) segments.push(finalSegment);
	else if (segments.length === 0) return undefined;

	const executables = segments.map((segment) => {
		const firstWord = segment.match(/^(?:"([^"]+)"|'([^']+)'|([^\s]+))/);
		const executable = firstWord?.[1] ?? firstWord?.[2] ?? firstWord?.[3];
		return executable && !executable.includes("=") ? basename(executable) : undefined;
	});

	return executables.every((executable): executable is string => executable !== undefined)
		? executables
		: undefined;
}

export default function shellPermission(pi: ExtensionAPI) {
	const allowedExecutables = new Set<string>();

	async function approve(command: string, ctx: ExtensionContext): Promise<boolean> {
		const executables = simpleExecutables(command);
		if (
			executables &&
			executables.every(
				(executable) =>
					ALWAYS_ALLOWED_EXECUTABLES.has(executable) || allowedExecutables.has(executable),
			)
		) {
			return true;
		}

		// Fail closed in print/JSON mode, where pi cannot ask the user.
		if (!ctx.hasUI) return false;

		const uniqueExecutable =
			executables && new Set(executables).size === 1 ? executables[0] : undefined;
		const allowExecutable = uniqueExecutable
			? `Allow “${uniqueExecutable}” for this session (all arguments)`
			: undefined;
		const choices = [ALLOW_ONCE];
		if (allowExecutable) choices.push(allowExecutable);
		choices.push(DENY);

		const choice = await ctx.ui.select(
			`Shell command requested:\n\n${command}\n\nRun it?`,
			choices,
		);

		if (choice === ALLOW_ONCE) return true;
		if (allowExecutable && choice === allowExecutable) {
			allowedExecutables.add(uniqueExecutable!);
			ctx.ui.notify(`Allowed ${uniqueExecutable} commands for this session`, "warning");
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
		if (!ctx.hasUI) return false;

		const choice = await ctx.ui.select(
			`External file change requested (${operation}):\n\n${target}\n\nAllow it?`,
			[ALLOW_ONCE, DENY],
		);

		return choice === ALLOW_ONCE;
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

	// Gate built-in tools that modify the filesystem. Reads and searches are not
	// gated; paths resolving inside cwd continue without a prompt.
	pi.on("tool_call", async (event, ctx) => {
		if (!PATH_TOOL_NAMES.has(event.toolName)) return;
		const rawPath = (event.input as { path?: unknown }).path;
		if (typeof rawPath !== "string") return;

		if (!(await approveExternalPath(rawPath, event.toolName, ctx))) {
			return {
				block: true,
				reason: ctx.hasUI
					? "External file change denied by user"
					: "External file change blocked because no confirmation UI is available",
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
				`Always-allowed executables: ${[...ALWAYS_ALLOWED_EXECUTABLES].sort().join(", ")}\nSession-allowed executables: ${executables.join(", ") || "none"}`,
				"info",
			);
		},
	});

	pi.registerCommand("shell-permissions-clear", {
		description: "Revoke all shell permissions granted during this session",
		handler: async (_args, ctx) => {
			allowedExecutables.clear();
			ctx.ui.notify("Cleared all shell permissions", "info");
		},
	});

}
