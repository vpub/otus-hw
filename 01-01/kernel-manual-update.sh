#!/bin/bash

# Update and install packets
yum update -y
yum install -y \
	wget \
	kernel-tools \
	gcc \
	binutils \
	perl \
	make \
	ncurses-devel \
	flex \
	openssl-devel \
	grub2 \
	bison \
	openssl \
	openssl-devel \
	bc \
	elfutils-libelf-devel \
	deltarpm

# Make directory for src and go there
mkdir -p /usr/src/linux-src/ && cd /usr/src/linux-src/

# Download new kernel
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.5.4.tar.xz

# Unzip new kernel, delete archive and go to kernel directory
tar -xvf linux-5.5.4.tar.xz && rm -f linux-5.5.4.tar.xz && cd linux-5.5.4/

#Compile and install new kernel, using old kernel configuration
cp -f /boot/config-`uname -r` .config
make olddefconfig
make -j"$(nproc)" bzImage && make -j"$(nproc)" modules && make -j"$(nproc)" && make modules_install && make install

# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-set-default 0 && echo "Grub update done."

#Building the VirtualBox Guest Additions kernel modules.
/sbin/rcvboxadd quicksetup all

# Reboot VM
shutdown -r now
