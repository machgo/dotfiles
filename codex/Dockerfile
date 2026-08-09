FROM node:22-bookworm-slim

ARG CODEX_VERSION=0.147.0
ARG USER_UID=1000
ARG USER_GID=1000

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        bash \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg \
        jq \
        openssh-client \
        python3 \
        python3-pip \
        python3-venv \
        ripgrep \
        tini \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        docker-buildx-plugin \
        docker-ce-cli \
        docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --global "@openai/codex@${CODEX_VERSION}" \
    && npm cache clean --force \
    && codex --version

# The Node base image reserves UID/GID 1000. Replace that account so the
# container user can match the caller, including macOS users whose GID is an
# existing Debian system group.
RUN set -eux; \
    if getent passwd node >/dev/null; then userdel --remove node; fi; \
    if getent group node >/dev/null; then groupdel node; fi; \
    if getent group "${USER_GID}" >/dev/null; then \
        user_group="$(getent group "${USER_GID}" | cut -d: -f1)"; \
    else \
        user_group=codex; \
        groupadd --gid "${USER_GID}" "${user_group}"; \
    fi; \
    useradd --create-home --uid "${USER_UID}" --gid "${user_group}" --shell /bin/bash codex; \
    install -d -o codex -g "${user_group}" /home/codex/.codex /workspace

ENV HOME=/home/codex
ENV CODEX_HOME=/home/codex/.codex

USER codex
WORKDIR /workspace

ENTRYPOINT ["codex"]
