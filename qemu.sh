#!/usr/bin/env bash

## This script is executed by host inside docker to run QEMU RISC-V guest
OUTPUT_DIR=/opt/bin
OPENSBI_FW_JUMP_ELF=$OUTPUT_DIR/fw_jump.elf
LINUX_IMAGE=$OUTPUT_DIR/Image
BUILDROOT_ROOTFS_CPIO=$OUTPUT_DIR/rootfs.cpio
ROOTFS_EXT4=$OUTPUT_DIR/rootfs.ext4

echo "QEMU"
# Using 9pfs
qemu-system-riscv64 \
	-M virt -nographic \
	-smp $(nproc) -cpu rv64,h=true,v=true \
	-m 6G \
	-bios $OPENSBI_FW_JUMP_ELF \
	-kernel $LINUX_IMAGE \
	-device virtio-net-device,netdev=usernet \
	-netdev user,id=usernet\
	-virtfs local,path=/temp-rootfs,mount_tag=rootfs,security_model=none,id=rootfs \
	-append "root=rootfs rw rootfstype=9p rootflags=trans=virtio,cache=mmap,msize=512000 console=ttyS0 earlycon=sbi nokaslr rdinit=/sbin/init" \
	-virtfs local,path=/linux-loader,mount_tag=test,security_model=mapped,id=test
exit $?

# Using ext4
# qemu-system-riscv64 \
# 	-M virt -nographic \
# 	-smp $(nproc) -cpu rv64,h=true \
# 	-m 4G \
# 	-bios $OPENSBI_FW_JUMP_ELF \
# 	-kernel $LINUX_IMAGE \
# 	-device virtio-net-device,netdev=usernet \
# 	-netdev user,id=usernet\
# 	-append "root=/dev/vda rw console=ttyS0 earlycon=sbi nokaslr rdinit=/sbin/init" \
# 	-drive file=$ROOTFS_EXT4,format=raw,id=hd0 \
# 	-device virtio-blk-device,drive=hd0 \
# 	-virtfs local,path=/linux-loader,mount_tag=test,security_model=mapped,id=test
# exit $?



	# -append "root=/dev/ram rw console=ttyS0 earlycon=sbi initrd=0xd0000000,50M" \
	# -device loader,addr=0xd0000000,file=$BUILDROOT_ROOTFS_CPIO \
	# -append "root=/dev/ram rw console=ttyS0 earlycon=sbi nokaslr rdinit=/sbin/init" \
	# -initrd $BUILDROOT_ROOTFS_CPIO \
	# -append "root=/dev/ram rw console=ttyS0 earlycon=sbi nokaslr initrd=0xd0000000,1200M rdinit=/sbin/init" \
	# -device loader,addr=0xd0000000,file=$BUILDROOT_ROOTFS_CPIO \
	# mkdir /mnt/my9p
	# mount -t 9p -o trans=virtio,version=9p2000.L host0 /mnt/my9p
	# -device virtio-net-device,netdev=usernet \
	# -netdev user,id=usernet,hostfwd=tcp::22222-:22222,hostfwd=tcp::10022-:22

	# -object rng-random,filename=/dev/urandom,id=rng0 \
	# -device virtio-rng-device,rng=rng0 \

	# -netdev user,id=usernet,hostfwd=tcp::22222-:22222,net=192.168.76.0/24,dhcpstart=192.168.76.9
	# -device virtio-net-device,netdev=usernet \
	# -netdev user,id=usernet,hostfwd=tcp:127.0.0.1:22222-:22222,hostfwd=tcp::20080-:80,hostfwd=tcp::28080-:8080 \
	# -device virtio-net-device,netdev=net0 -netdev user,id=net0,hostfwd=tcp::22222-:22222
	# -device virtio-net-device,netdev=net0 -netdev user,id=net0,hostfwd=tcp::22222-:22222
	# -device virtio-net-device,netdev=usernet -netdev user,id=usernet,hostfwd=tcp::45455-:45455
	# -monitor telnet::45454,server,nowait \
	# -net user,hostfwd=tcp::45455-:45455
	# -device e1000,netdev=net0 \
	# -netdev user,id=net0,hostfwd=tcp::45455-:45455
	# -device virtio-net-device,netdev=usernet \
	# -netdev user,id=usernet,hostfwd=tcp::45455-:45455

