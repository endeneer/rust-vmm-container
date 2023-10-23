#!/usr/bin/env bash

OUTPUT_DIR=/opt/bin
OPENSBI_FW_JUMP_ELF=$OUTPUT_DIR/fw_jump.elf
LINUX_IMAGE=$OUTPUT_DIR/Image
BUILDROOT_ROOTFS_CPIO=$OUTPUT_DIR/rootfs.cpio

echo "QEMU"
qemu-system-riscv64 \
	-M virt -nographic \
	-smp 4 -cpu rv64,h=true,v=true \
	-m 4G \
	-bios $OPENSBI_FW_JUMP_ELF \
	-kernel $LINUX_IMAGE \
	-append "root=/dev/ram rw console=ttyS0 earlycon=sbi nokaslr" \
	-initrd $BUILDROOT_ROOTFS_CPIO \
	-device virtio-net-device,netdev=usernet \
	-netdev user,id=usernet\
	-virtfs local,path=/linux-loader,mount_tag=host0,security_model=mapped,id=host0
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

