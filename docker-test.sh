#!/usr/bin/env bash

REPO_DIR=/tmp/linux-loader
REPO_MOUNT_POINT=/workdir

## CI: build-gnu-riscv64
docker run -it --rm -v $REPO_DIR:$REPO_MOUNT_POINT --workdir $REPO_MOUNT_POINT rustvmm/dev:v29_riscv64 sh -c -e "RUSTFLAGS=\"-D warnings\" cargo build --release --target=riscv64gc-unknown-linux-gnu --config target.riscv64gc-unknown-linux-gnu.linker=\\\"riscv64-linux-gnu-gcc\\\" && chown -R $(id -u):$(id -u) $REPO_MOUNT_POINT"

## CI: unittests-gnu-riscv64
docker run -it --rm -v $REPO_DIR:$REPO_MOUNT_POINT --workdir $REPO_MOUNT_POINT rustvmm/dev:v29_riscv64 sh -c -e "cargo test --no-run --target=riscv64gc-unknown-linux-gnu --config target.riscv64gc-unknown-linux-gnu.linker=\\\"riscv64-linux-gnu-gcc\\\" && qemu.sh && chown -R $(id -u):$(id -u) $REPO_MOUNT_POINT"
