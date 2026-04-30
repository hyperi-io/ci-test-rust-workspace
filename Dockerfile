# Project:   ci-test-rust-workspace
# File:      Dockerfile
# Purpose:   Container image for the workspace's cli member binary
# License:   FSL-1.1-ALv2
# Copyright: (c) 2026 HYPERI PTY LIMITED

# -- Build stage ---------------------------------------------------------------
FROM rust:1.82-slim AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential pkg-config libssl-dev \
       gcc-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

RUN rustup target add aarch64-unknown-linux-gnu

WORKDIR /build

# Copy the entire workspace — manifests + sources together. Workspace
# builds need both members regardless of which member produces the
# final binary.
COPY Cargo.toml Cargo.lock* ./
COPY crates/ ./crates/

ARG TARGETARCH=amd64

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
        export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc; \
        cargo build --release --bin ci-test-rust-workspace --target aarch64-unknown-linux-gnu; \
        cp target/aarch64-unknown-linux-gnu/release/ci-test-rust-workspace /build/ci-test-rust-workspace; \
    else \
        cargo build --release --bin ci-test-rust-workspace --target x86_64-unknown-linux-gnu; \
        cp target/x86_64-unknown-linux-gnu/release/ci-test-rust-workspace /build/ci-test-rust-workspace; \
    fi

# -- Runtime stage -------------------------------------------------------------
FROM debian:bookworm-slim

RUN useradd --create-home --uid 10001 --shell /bin/bash appuser

COPY --from=builder --chown=appuser:appuser /build/ci-test-rust-workspace /usr/local/bin/ci-test-rust-workspace

USER appuser

HEALTHCHECK --interval=30s --timeout=3s --start-period=2s --retries=2 \
    CMD ci-test-rust-workspace --version || exit 1

ENTRYPOINT ["ci-test-rust-workspace"]
