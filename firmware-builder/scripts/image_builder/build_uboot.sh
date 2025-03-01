#!/bin/bash


build_uboot() {
    log info "Start Building: U-BOOT !!!"
    cd $BUILDING
    git clone --depth=1 https://source.denx.de/u-boot/u-boot.git
    cd u-boot

    log info "Compiling U-BOOT !!!"
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- rpi_arm64_defconfig
    make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
    log info "Copying: u-boot.bin to: $BOOTFS !!!"
    cp u-boot.bin $BOOTFS/
    log succ "Finsihed building u-boot image !!!"

}