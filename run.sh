#!/usr/bin/env bash

REPO_DIR=/tmp/linux-loader
REPO_MOUNT_POINT=/workdir
docker run -it -v $REPO_DIR:$REPO_MOUNT_POINT --workdir $REPO_MOUNT_POINT rustvmm/dev:v29_riscv64 bash
