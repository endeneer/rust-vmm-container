#!/usr/bin/env bash

ip addr
# echo nameserver 8.8.8.8 > /etc/resolv.conf
git --version
rustc -vV
gcc -v
which cargo
cargo --version
ls /dev/kvm
ping -c 1 github.com

echo "Mounting..."
mkdir -p /test
# mount -t 9p -o trans=virtio,version=9p2000.L,cache=mmap host0 /test
#mount -t 9p -o trans=virtio,version=9p2000.L,posixacl,msize=104857600 host0 /test
mount -t 9p -o trans=virtio,version=9p2000.L,posixacl,msize=104857600,cache=loose host0 /test
mount
cd /test

cd /
git clone --depth 1 --branch patch-riscv https://github.com/endeneer/linux-loader.git
# mkdir -p /linux-loader
# cp -a /test/. /linux-loader/.
cd /linux-loader

echo "Starting rust-vmm test..."
cargo test --verbose --config target.riscv64gc-unknown-linux-gnu.linker=\"gcc\" 
#cargo build --release --verbose --config target.riscv64gc-unknown-linux-gnu.linker=\"gcc\" 

echo "Exiting QEMU..."
devmem 0x100000 w 0x93333
