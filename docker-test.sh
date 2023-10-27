#!/usr/bin/env bash

REPO_DIR=/tmp/linux-loader
REPO_MOUNT_POINT=/workdir
docker run -v $REPO_DIR:$REPO_MOUNT_POINT rustvmm/dev:v29_riscv64 bash -c "cd $REPO_MOUNT_POINT && cargo test --no-run --target=riscv64gc-unknown-linux-gnu --config target.riscv64gc-unknown-linux-gnu.linker=\\\"riscv64-linux-gnu-gcc\\\" && echo hi > /workdir/hello.txt && qemu.sh"
# docker run -v $HOST_DIR:/test rustvmm/dev:v29_riscv64 bash -c "cd /test && ./qemu.sh"
