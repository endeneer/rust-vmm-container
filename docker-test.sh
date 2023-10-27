#!/usr/bin/env bash

HOST_DIR=/home/user/git/worktree/personal/kvm-ioctls-riscv/rust-vmm-container
docker run -v $HOST_DIR:/test rustvmm/dev:v29_riscv64 bash -c "cd /linux-loader && cargo test --no-run --target=riscv64gc-unknown-linux-gnu --config target.riscv64gc-unknown-linux-gnu.linker=\\\"riscv64-linux-gnu-gcc\\\" && cd /test && ./qemu.sh"
# docker run -v $HOST_DIR:/test rustvmm/dev:v29_riscv64 bash -c "cd /test && ./qemu.sh"

