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
    eco info "Installing HEADERS - for RPI5..."
    log info "Installing HEADERS - for RPI5..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- headers_install INSTALL_HDR_PATH=$ROOTFS/usr
    eco info "Installing MODULES - for RPI5..."
    log info "Installing MODULES - for RPI5..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=$ROOTFS modules_install
    eco info "Building zImage and dtbs..."
    log info "Building zImage and dtbs..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- zImage
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dtbs

    eco info "Copying zImage - for RPI5..."
    log info "Copying DTB's - for RPI5..."
    cp arch/arm64/boot/zImage $BOOTFS
    cp arch/arm64/boot/dts/broadcom/*.dtb $BOOTFS

}
