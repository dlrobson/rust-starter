# Rust Starter

This is a sample starter project for Rust. It includes a simple hello world program. Adds several GitHub Actions workflows for CI/CD. It utilizes Docker build environments for faster builds, and to support a Dev Container setup.

## Docker Build Image

The Docker build image is based on the official Rust image. It includes several tools for development. The Dockerfile is located in `dockerfiles/build.Dockerfile`.

The Build image is created in GitHub Actions and pushed to GitHub Container Registry. The image is tagged as `ghcr.io/<owner>/<repo>-build-env:latest`. This image is utilized in subsequent steps. It is triggered only on changes to the Dockerfile or the GitHub Actions workflow.

## GitHub Actions Workflows

Several workflows are included in the repository. They are triggered on different events.

### Analyzers

- rustfmt
- cargo-spellcheck
- clippy
- cargo-audit

### Tests

- cargo test (Includes doc tests)
- coverage (via grcov). Defaults to 70% coverage threshold requirement. The build will fail if the coverage is below the threshold.
