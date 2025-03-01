#!/bin/bash



build_image() {

    log info "Flashing to SDCard ... .. ."
    sudo fdisk -l
    read -p "Enter Target-Device: " dev
    log info "Partitioning SDCard ... .. ."
    sudo parted $dev --script mklabel msdos
    sudo parted $dev --script mkpart primary fat32 1MiB 256MiB
    sudo parted $dev --script mkpart primary ext4 256MiB 100%

    log info "Formating SDCard! ... ."
    sudo mkfs.vfat $dev + "1"
    sudo mkfs.ext4 $dev + "2"

# Partitionen mounten und Dateien kopieren
    log info "Mounting Partitions & Copy to Target!!! ... ."
    mkdir -p /mnt/{boot,rootfs}
    sudo mount $dev1 /mnt/boot
    sudo mount $dev2 /mnt/rootfs

    sudo cp -r boot/* /mnt/boot/
    sudo cp -r rootfs/* /mnt/rootfs/
    log info "Unmount Partitions! ... ."
    sudo umount /mnt/boot /mnt/rootfs
    sync
}