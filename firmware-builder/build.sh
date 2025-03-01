#!/bin/bash

source $(pwd)/scripts/funcs/functions.sh


source $(pwd)/scripts/build_config_files.sh
source $(pwd)/scripts/build_busybox.sh

source $(pwd)/scripts/build_libarys.sh
source $(pwd)/scripts/build_toolchain.sh
source $(pwd)/scripts/build_packages.sh

source $(pwd)/scripts/builder/set_permissions.sh



source $(pwd)/scripts/image_builder/build_kernel.sh
source $(pwd)/scripts/image_builder/build_bootfs.sh
source $(pwd)/scripts/image_builder/build_rootfs.sh
source $(pwd)/scripts/image_builder/build_uboot.sh
source $(pwd)/scripts/image_builder/build_initramfs.sh

### END IMPORT BUILDER FUNCTIONS ### END IMPORT BUILDER FUNCTIONS ### END IMPORT BUILDER FUNCTIONS ###


### EXPORT VARIABLES ### EXPORT VARIABLES ### EXPORT VARIABLES ### ###########
export PROJEKT_DIR=$(pwd)
export BUILDING=$(pwd)/work

export OUTPUT=$(pwd)/output
export IMAGES=$(pwd)/output/images 

export BOOTFS=$(pwd)/work/bootfs
export ROOTFS=$(pwd)/work/rootfs

export LOG_DIR=$(pwd)/logs
export LOG_FILE=$(pwd)/logs/firmware-builder.log

### END EXPORT VARIABLES ### END EXPORT VARIABLES ### END EXPORT VARIABLES ###





### CREATES ROOTFS_DIR, BOOTFS_DIR & WORKING_DIR 
eco info "Creating: $ROOTFS, $BOOTFS, $BUILDING, $IMAGES, $LOG_DIR"
log info "Creating: $ROOTFS, $BOOTFS, $BUILDING, $IMAGES, $LOG_DIR"
sudo mkdir -p $ROOTFS $BOOTFS $BUILDING $LOG_DIR $IMAGES








welcome() {
    reset;
    echo "============================================================================="
    echo "= Welcome to the Firmware Builder! Version: 0.0.1 Beta                      ="
    echo "= This script will build your custom Linux Firmware for your Raspberry Pi.  ="
    echo "============================================================================="                                              
    echo "= Author: hexzhen3x7 || Build-Version: 0.0.1 Beta  || Firmware Builder      ="
    echo "============================================================================="    

                                
}



build_rootfs() {

    eco info "Creating ROOTFS's - Directorys !!!... .. ."
   
    mkdir -p $ROOTFS/{bin,sbin,etc/{init.d,udev/{rules.d},cron.d,network},lib,lib64,usr/{src,bin,lib,include,sbin},home,opt,mnt,dev,proc,sys,root,tmp,var}
    chmod 1777 $ROOTFS/tmp  

    sudo mount -t proc proc $ROOTFS/proc
    sudo mount -t sysfs sysfs $ROOTFS/sys
    sudo mount -t devtmpfs devtmpfs $ROOTFS/dev
    sudo mount -t tmpfs tmpfs $ROOTFS/tmp


    eco info "Creating: $ROOTFS/init !!!"
    log info "Creating: $ROOTFS/init !!!"
    create_init;

    eco info "Creating: inittab !!!"
    log info "Creating: inittab !!!"
    create_inittab;

    eco info "Creating: /etc/init.d/rcS !!!"
    log info "Creating: /etc/init.d/rcS !!!"
    create_initd_rcs;

    eco info "Creating: /etc/fstab !!!"
    log info "Creating: /etc/fstab !!!"
    create_fstab;

    eco info "Creating: /etc/hostname  !!!"
    log info "Creating: /etc/hostname  !!!"
    create_hostname;

    eco info "Creating: /etc/network/interfaces !!!"
    log info "Creating: /etc/network/interfaces !!!"
    create_ifaces;

    eco info "Creating: /etc/hosts !!!"
    log info "Creating: /etc/hosts !!!"
    create_hosts;


    eco info "Creating: /etc/profile !!!"
    log info "Creating: /etc/profile !!!"
    create_profile;

    eco info "Creating: /etc/passwd !!!"
    log info "Creating: /etc/passwd !!!"
    create_passwd;

    eco info "Creating: /etc/group !!!"
    log info "Creating: /etc/group !!!"
    create_group;

    eco info "Creating: /etc/shadow !!!"
    log info "Creating: /etc/shadow !!!"
    create_devices;
    
    eco info "Creating: /etc/motd !!!"
    log info "Creating: /etc/motd !!!"
    create_motd;

    eco info "Creating: /etc/resolv.conf !!!"
    log info "Creating: /etc/resolv.conf !!!"
    create_resolv;

    eco info "Creating: /dev/* !!!"
    log info "Creating: /dev/* !!!"
    create_devices;

    eco info "Creating: /etc/rc.local !!!"
    log info "Creating: /etc/rc.local !!!"
    create_rclocal;

    eco info "Creating: LDSOCONF !!!"
    log info "Creating: /etc/ld.so.conf !!!"
    create_ldsoconf;

    eco info "Creating: /etc/init.d/networking !!!"
    log info "Creating: /etc/init.d/networking !!!"
    create_networking;
    
    eco info "Creating: /etc/udev/rules.d/10-local.rules!!!"
    log info "Creating: /etc/udev/rules.d/10-local.rules !!!"
    create_udev;


    eco succ "FINISHED-BUILD: Initialize Files!!!"
    log info "FINISHED-BUILD: Initialize Files!!!"


}


build_images() {
    eco info "Creating: BOOTFS IMAGE !!!"
    log info "Creating: BOOTFS IMAGE !!!"
    
    build_initramfs;
    build_bootfs;
    build_uboot;
    build_rootfs_image;
}





initialize() {
   # PROCESSES={build_rootfs,build_busybox,build_gmp,build_mpfr,build_mpc,build_gcc,build_glibc,build_zlib,build_db,build_toolchain_rpi,build_toolchain,build_bash,build_rpm,build_opkg,set_permissions}
    
    welcome;

    build_rootfs;
    sleep 2;
    build_busybox;
    sleep 2;
    build_toolchain;
    sleep 2;
    build_toolchain_rpi;
    sleep 2;
    build_libarys;
    sleep 2;
    build_packages:
    sleep 2;
    set_permissions;
    sleep 2;
    build_kernel;
    sleep 2;
    build_initramfs;
    sleep 2;
    build_uboot;
    sleep 2;
    build_bootfs;
    sleep 2;
}


initialize;