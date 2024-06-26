# syntax=docker/dockerfile:1

# Derived from the official
FROM rust:1.79.0-slim-bookworm AS planner

USER root

RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

# Install cargo-binstall and cargo-chef
RUN curl -L --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash \
    && cargo-binstall -y cargo-chef

# Copy the project files, and prepare the build
WORKDIR /app
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM rust:1.79.0-slim-bookworm AS cacher

RUN apt-get update && apt-get install -y \
    sudo curl lcov \
    && rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000
ARG USERNAME=ubuntu

RUN groupadd -g ${GID} ${USERNAME} \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd;

# Set USER to non-root user
USER ${USERNAME}

# Re-install cargo-binstall and cargo-chef
COPY --from=planner --chown=${UID}:${GID} /app/recipe.json /tmp/recipe.json
RUN mkdir -p /tmp/workspaces \
    && mv /tmp/recipe.json /tmp/workspaces/recipe.json \
    && cd /tmp/workspaces \
    && curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash \
    && cargo binstall -y cargo-chef \
    && cargo chef cook --release --recipe-path recipe.json \
    && cargo uninstall cargo-chef cargo-binstall \
    && rm -rf /tmp/workspaces
