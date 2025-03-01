#!/bin/bash

build_kernel() {
    eco info "Building Kernel... .. ."
    log info "Building Kernel... .. ."

    cd $BUILDING 
    git clone https://github.com/firmware-builderz/linux
    cd linux

    eco info "Configuring with: bcm2712_defconfig - for RPI5..."
    log info "Configuring with: bcm2712_defconfig - for RPI5..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2712_defconfig
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- headers_install INSTALL_HDR_PATH=$ROOTFS/usr
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=$ROOTFS modules_install
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- zImage
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dtbs

    cp arch/arm64/boot/zImage $BOOTFS
    cp arch/arm64/boot/dts/broadcom/*.dtb $BOOTFS

}
