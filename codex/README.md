# Containerized Codex CLI

Run the Codex CLI in an isolated development container while working on the
repository in your current directory. Authentication, configuration, plugins,
session history, and other home-directory state persist in the
`codex-container-home` Docker volume.

The image contains Git, an SSH client, curl, ripgrep, jq, Node.js, Python,
common native build tools, and the Docker CLI with Compose and Buildx plugins.
It pins Codex CLI `0.147.0` by default.

## Requirements

- Docker Engine or Docker Desktop
- Docker Compose v2 (`docker compose`)

## Install the launcher

Run it directly from this repository:

```sh
/path/to/codex/codex-container
```

Or link it into a directory on your `PATH`:

```sh
ln -s /path/to/codex/codex-container ~/.local/bin/codex-container
```

The first invocation builds the image for your host UID and GID. This keeps
files created under the mounted project directory owned by your host user.

## Authenticate

Codex supports ChatGPT and API-key authentication. For an isolated interactive
login, use the device flow:

```sh
codex-container login --device-auth
```

The credentials are stored in the named home volume, not in the image or the
host's `~/.codex` directory. Confirm the stored login with:

```sh
codex-container login status
```

See the official OpenAI documentation for [Codex CLI setup][codex-cli] and
[authentication options][auth].

## Use Codex

Change to any project and start a session:

```sh
cd /path/to/project
codex-container
```

Arguments are passed through to Codex:

```sh
codex-container "Explain this project"
codex-container resume --last
codex-container exec "Run the test suite and summarize failures"
```

Launcher flags must come before Codex arguments. Use `--` when a Codex flag
conflicts with a launcher flag:

```sh
codex-container -- --help
```

## Opt in to host Docker access

Docker tooling is installed in every image, but the host daemon is only exposed
when `--docker` is supplied:

```sh
codex-container --docker
codex-container --docker exec "Build the project images"
```

The launcher detects the active Unix Docker socket and adds its group to the
container process. `--docker` effectively grants the session broad control over
the host's Docker resources and should only be used for trusted workspaces.

## Rebuild or upgrade

Force a rebuild while keeping the pinned version:

```sh
codex-container --rebuild
```

Choose a different Codex version for an intentional upgrade:

```sh
CODEX_VERSION=0.148.0 codex-container --rebuild -- --version
```

The image tag includes the Codex version and host UID/GID, while the persistent
home volume remains shared across rebuilds.

## Reset persistent state

Sign out without deleting configuration and history:

```sh
codex-container logout
```

To remove all containerized Codex state, first close active sessions and then
delete the named volume:

```sh
docker volume rm codex-container-home
```

This deletion cannot be undone. It does not affect the host's `~/.codex`
directory.

[codex-cli]: https://learn.chatgpt.com/docs/codex/cli
[auth]: https://learn.chatgpt.com/docs/auth
