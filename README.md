# Rust Starter

This is a simple starter project for Rust. It includes a simple hello world program. Adds the following checks through GitHub Actions.

**Analyzers**
- rustfmt
- cargo-spellcheck
- clippy
- cargo-audit

**Tests**
- cargo test (Includes doc tests)
- coverage (via grcov). Defaults to 70% coverage threshold.

## GitHub Actions Nuances

- Uses a build image with rust installed and other tools. The Dockerfile is included in the repository in `dockerfiles/build.Dockerfile`.
- Uploads the build image to GitHub Container Registry. This is utilized for subsequent steps. Named `ghcr.io/<owner>/<repo>-build-env:latest`. This is useful for a Dev Container setup.
- For PRs, a build image is created and pushed with the name `ghcr.io/<owner>/<repo>-build-env:PR-<PR_NUMBER>`. This validates the Dockerfile and that tests can run. This image is deleted after the PR is closed.
- Utilizes Cache for faster builds. Caches the target directory.
- Ends jobs early if a new commit is pushed for the same PR.
