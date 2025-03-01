#!/bin/bash




build_bootfs() {
    log info "BUILDING: BOOTFS!!!"
    
    log info "Downloading BOOTFS..."
    cd $BUILDING 
    git clone --depth=1 https://github.com/raspberrypi/firmware.git
    
    log info "Copying BOOT-FILES to BOOTFS..."
    sudo cp -r firmware/boot/* $BOOTFS 

    log info "CD into: $BOOTFS!!!"
    cd $BOOTFS

    log info "Creating cmdline.txt !!!"
    echo "root=/dev/mmcblk0p2 rw rootfstype=ext4 init=/init console=ttyS0,115200" > cmdline.txt
    echo "console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 fsck.repair=yes rootwait
    " > cmdline2.txt


    log info "Creating config.txt !!!"
    cat <<EOF > config.txt
# For more options and information see
# http://rpf.io/configtxt
# Some settings may impact device functionality. See link above for details
gpu_mem=128
enable_uart=1
kernel=Image
device_tree=bcm2712-rpi-5-b.dtb
auto_initramfs=1
EOF

    
    log info "Entering: $OUTPUT"
    cd $OUTPUT

    log info "Creating boot.vfat Image!!!"
    sudo dd if=/dev/zero of=boot.vfat bs=1M count=256 status=progress

    log info "Creating 'boot.vfat' Filesystem!!!"
    sudo mkfs.vfat boot.vfat

    log info "Mounting 'boot.vfat' Filesystem!!!"
    sudo mount -o loop boot.vfat /mnt/boot

    log info "Copying BOOTFS to 'boot.vfat' Filesystem!!!"
    sudo cp -r $BOOTFS/* /mnt/boot

    log info "Listing current BOOTFS's Files !!!"
    ls -lh /mnt/boot >> $LOG_DIR/bootfs-build.log

    log info "Unmounting 'boot.vfat' Filesystem!!!"
    sudo umount 

    log info "Finished building BOOTFS!!!"
}


flash_image() {
    log info "FLASHING: IMAGE!!!"
    
    log info "Listing Devices !!!"
    sudo fdisk -l 


    read -p "Selected Device: " dev
    log info "Formating Device: $dev !!!"
    
    dev="${dev}1"
    sudo mkfs.vfat -F 32 /dev/$dev
    dev="${dev}2"

    sudo mkfs.ext4 /dev/$dev
    log succ "Finsihed formatting devices !!!"


    log info "Mounting $dev at /mnt/rootfs !!!"
    sudo mkdir -p /mnt/rootfs
    sudo mount /dev/$dev  /mnt/rootfs

    log info "Copying $ROOTFS to /mnt/rootfs !!!"
    sudo cp -a rootfs/* /mnt/

    log info "Unmounting /mnt/rootfs !!!"
    sudo umount $dev 

    log succ "Finsihed flashing image !!!"

}