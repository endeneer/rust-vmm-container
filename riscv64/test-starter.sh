#!/usr/bin/env bash

## This script is executed by QEMU RISC-V guest during systemd boot (see test.service)
## This script does the following things:
## 1) mount the repo to be tested at $REPO_MOUNT_POINT
## 2) find pre-cross-compiled test binaries under $REPO_MOUNT_POINT/target/riscv64gc-unknown-linux-gnu/debug/deps/*
## 3) Run each of those found test binaries

## QEMU virtfs mount_tag
REPO_MOUNT_TAG=test
## Where to mount the repo to be tested, the repo shall be pre-cross-compiled in host machine
REPO_MOUNT_POINT=/test

## $1: The exit code (in decimal) that you want QEMU to exit with
exit_qemu_with_code() {
	local exit_code=$1
	local exit_code_in_hex=$(printf "0x%x" $exit_code)
	local encoded_exit_code=$(printf "0x%x" $(( ($exit_code_in_hex << 16) + 0x3333)))
	echo "Exiting QEMU with exit code $exit_code..."
	## Trigger QEMU exit by writing to SiFive Test MMIO device at 0x100000
	echo "devmem 0x100000 w $encoded_exit_code"
	devmem 0x100000 w $encoded_exit_code
}

## Dependencies check
ls /dev/kvm || exit_qemu_with_code $?
#ping -c 1 github.com || exit_qemu_with_code $?
#git --version || exit_qemu_with_code $?
#rustc -vV || exit_qemu_with_code $?
#gcc -v || exit_qemu_with_code $?
#cargo --version || exit_qemu_with_code $?

echo "Mounting repo to be tested..."
mkdir -p $REPO_MOUNT_POINT
mount -t 9p -o rw,trans=virtio,version=9p2000.L,posixacl,msize=512000,cache=mmap $REPO_MOUNT_TAG $REPO_MOUNT_POINT
mount | grep 9p

# cd /
#git clone --depth 1 --branch patch-riscv https://github.com/endeneer/linux-loader.git
# mkdir -p /linux-loader
# cp -a /test/. /linux-loader/.
# cd /linux-loader

echo "Searching for cross-compiled test binaries..."
IFS=$'\n'
test_bin=($(find $REPO_MOUNT_POINT/target/riscv64gc-unknown-linux-gnu/debug/deps/* -perm /+x))
unset IFS

echo "List of cross-compiled test binaries found..."
printf "%s\n" "${test_bin[@]}"

echo "Running the cross-compiled test binaries..."
for (( i = 0; i < ${#test_bin[@]} ; i++ )); do
	echo "*****************************************"
	echo "Running: ${test_bin[$i]}"
	echo "*****************************************"
	eval "${test_bin[$i]}" || exit_qemu_with_code $?
done

## TODO: Native build/test are to be enabled when Rust native RISC-V compiler becomes stable enough
## Example commands to be used for native build/test:
# cargo build --release --verbose --config target.riscv64gc-unknown-linux-gnu.linker=\"gcc\"
# cargo test --verbose --config target.riscv64gc-unknown-linux-gnu.linker=\"gcc\"

exit_qemu_with_code 0
