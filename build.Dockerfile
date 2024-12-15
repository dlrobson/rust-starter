# The final image. The base image is used to install the necessary dependencies
# required to begin building the project.
FROM rust:1.83.0-slim-bookworm AS base

ARG UID=1000
ARG GID=1000
ARG USERNAME=ubuntu
ARG CARGO_REGISTRY_PATH=/usr/local/cargo/registry

# Setup the user
RUN apt-get update && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd;
# Install cargo-chef
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall -y cargo-chef

# Create the dev image. This is useful for dev containers and adds specific
# setup for development.
FROM base AS dev

# Create a volume at CARGO_REGISTRY_PATH to cache the cargo registry
VOLUME [${CARGO_REGISTRY_PATH}]
RUN mkdir -p ${CARGO_REGISTRY_PATH} && \
    chown -R ${USERNAME}:${USERNAME} ${CARGO_REGISTRY_PATH}
USER ${USERNAME}

# The chef image. It is used to prepare the build. It is used to prepare the
FROM base AS chef
WORKDIR /app

# The planner image. It is used to prepare the build. It is used to prepare the
# build of the project
FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

# This builds the dependencies. It is used to build the dependencies of the
# project.
FROM chef AS builder
COPY --from=planner /app/recipe.json /app/recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

USER ${USERNAME}
