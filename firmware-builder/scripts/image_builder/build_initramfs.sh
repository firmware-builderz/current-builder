#!/bin/bash



build_initramfs() {
    eco info "INITRAMFS BUILDER STARTED !!!"
    log info "INITRAMFS BUILDER STARTED !!!"

    # Assuming that $ROOTFS and $BOOTFS are set and valid
    eco info "Changing WorkDirectory to: $ROOTFS !!!"
    log info "Changing WorkDirectory to: $ROOTFS !!!"
    cd $ROOTFS

    eco info "Creating: initramfs >> $BOOTFS/initramfs.gz !!!"
    log info "Creating: initramfs >> $BOOTFS/initramfs.gz !!!"
    find . | cpio -o -H newc | gzip > $BOOTFS/initramfs.gz

    eco info "Changing WorkDirectory to: $BUILDING !!!"
    cd $BUILDING

    eco succ "Successfully built $BOOTFS/initramfs.gz !!!"
    log succ "Successfully built $BOOTFS/initramfs.gz !!!"
}

