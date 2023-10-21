#!/usr/bin/env bash

HOST_DIR=/home/user/git/worktree/personal/kvm-ioctls-riscv/rust-vmm-container
docker run -it -v $HOST_DIR:/test rustvmm/dev:v29_riscv64 bash
