#!/bin/bash

build_kernel() {
    log info "Building Kernel... .. ."

    cd $BUILDING 
    git clone https://github.com/firmware-builderz/linux
    cd linux

    log info "Configuring with: bcm2712_defconfig - for RPI5..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2712_defconfig
    
    dl 2
    log info "Building zImage, Image, Modules and dtbs..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- zImage
    # make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dtbs
    # make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules
    dl 2
    sudo mkdir -p $ROOTFS/modules
    make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=$ROOTFS/modules modules_install
     #make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=~/modules modules_install
    # 2.3 Kopiere die Kernel-Module
    # sudo cp -a ~/modules/lib/modules/$(make kernelrelease) /mnt/lib/modules/
    dl 2
    log info "Installing HEADERS - for RPI5..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- headers_install INSTALL_HDR_PATH=$ROOTFS/usr

    dl 2
    log info "Copying DTB's - for RPI5..."
    cp arch/arm64/boot/Image $BOOTFS/kernel8.img
    cp arch/arm64/boot/dts/broadcom/*.dtb $BOOTFS
    cp -r arch/arm64/boot/dts/overlays $BOOTFS

    log info "Kernel build completed successfully!"
}
