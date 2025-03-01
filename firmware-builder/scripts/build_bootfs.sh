#!/bin/bash




build_bootfs() {
    eco info "BUILDING: BOOTFS!!!"
    log info "BUILDING: BOOTFS!!!"
    
    
   
    eco info "Downloading BOOTFS..."
    log info "Downloading BOOTFS..."
    cd $BUILDING 
    git clone --depth=1 https://github.com/raspberrypi/firmware.git
    eco info "Downlading BOOT-FILES!!!"
    log info "Downlading BOOT-FILES!!!"
    
    eco info "Copying BOOT-FILES to BOOTFS..."
    log info "Copying BOOT-FILES to BOOTFS..."
    sudo cp -r firmware/boot/* $BOOTFS 

    eco info "Changing dir to: $BOOTFS!!!"
    log info "CD into: $BOOTFS!!!"
    cd $BOOTFS

    eco info "Creating cmdline.txt !!!"
    echo "console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 fsck.repair=yes rootwait
    " > cmdline.txt


    eco info "Creating config.txt !!!"
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

    
    eco info "Entering: $OUTPUT"
    log info "Entering: $OUTPUT"
    cd $OUTPUT

    eco info "Creating boot.vfat Image!!!"
    log info "Creating boot.vfat Image!!!"
    sudo dd if=/dev/zero of=boot.vfat bs=1M count=256 status=progress

    eco info "Creating 'boot.vfat' Filesystem!!!"
    log info "Creating 'boot.vfat' Filesystem!!!"
    sudo mkfs.vfat boot.vfat

    eco info "Mounting 'boot.vfat' Filesystem!!!"
    log info "Mounting 'boot.vfat' Filesystem!!!"
    sudo mount -o loop boot.vfat /mnt/boot

    eco info "Copying BOOTFS to 'boot.vfat' Filesystem!!!"
    log info "Copying BOOTFS to 'boot.vfat' Filesystem!!!"
    sudo cp -r $BOOTFS/* /mnt/boot

    eco info "Listing current BOOTFS's Files !!!"
    log info "Listing current BOOTFS's Files !!!"
    ls -lh /mnt/boot >> $LOG_DIR/bootfs-build.log

    eco info "Unmounting 'boot.vfat' Filesystem!!!"
    log info "Unmounting 'boot.vfat' Filesystem!!!"
    sudo umount 

    eco info "Finished building BOOTFS!!!"
    log info "Finished building BOOTFS!!!"
}