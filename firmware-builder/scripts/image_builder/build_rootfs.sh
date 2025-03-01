#!/bin/bash


build_rootfs_image() {
    log info "Creating rootfs image !!!"
    cd $IMAGES

    dd if=/dev/zero of=rootfs.ext4 bs=1M count=512

    log info "Formating rootfs.ext4 !!!"
    sudo mount rootfs.ext4 /mnt/rootfs

    log info "Copying $ROOTFS to /mnt/rootfs !!!"
    sudo cp -a $ROOTFS/* /mnt/rootfs/

    log info "Unmounting rootfs and cleaning up..."
    sudo umount /mnt/rootfs
    sync



}