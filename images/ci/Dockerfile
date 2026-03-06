FROM ghcr.io/dlrobson/rust-ci:1.93.1-0

COPY binstall-versions.json /tmp/binstall-versions.json
RUN cargo binstall --no-confirm $(jq -r '.[] | "\(.crate)@\(.version)"' /tmp/binstall-versions.json)
