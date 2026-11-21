# Sandbox for Claude Code. The claude binary itself is NOT in the image: the
# host install (~/.local/share/claude) is mounted read-only by the launcher, so
# the container always runs the same version as the host.
FROM ubuntu:24.04

ARG USER_NAME
ARG USER_UID
ARG USER_GID
ARG USER_HOME

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash ca-certificates curl wget less nano file tree unzip zip xz-utils \
        procps psmisc jq ripgrep fd-find git openssh-client patch diffutils \
        build-essential cmake pkg-config \
        python3 python3-pip python3-venv python3-dev \
        python3-numpy python3-scipy python3-matplotlib python3-sympy \
        python3-pandas python3-pytest \
        maxima \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Same user, uid/gid and home path as on the host, so files written to the
# mounted directories are owned by you and ~/.claude/projects/<path> keys match.
RUN if id -u ubuntu >/dev/null 2>&1; then userdel -r ubuntu; fi \
    && groupadd -o -g "${USER_GID}" "${USER_NAME}" \
    && useradd -o -m -u "${USER_UID}" -g "${USER_GID}" -d "${USER_HOME}" \
               -s /bin/bash "${USER_NAME}"

USER ${USER_NAME}
WORKDIR ${USER_HOME}
