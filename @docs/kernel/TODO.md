


# Building Image, Modules & DTBS
```sh
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2712_defconfig
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
sudo cp arch/arm64/boot/Image /boot/kernel8.img
sudo cp arch/arm64/boot/dts/broadcom/bcm2712-rpi-5b.dtb /boot/
```