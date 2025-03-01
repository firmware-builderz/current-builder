#!/bin/bash



source /media/blackbyte/ssd/.global_scripts/colored.sh
source $(pwd)/scripts/logger.sh

source $(pwd)/scripts/build_config_files.sh
source $(pwd)/scripts/build_busybox.sh
source $(pwd)/scripts/build_libarys.sh
source $(pwd)/scripts/build_packages.sh

source $(pwd)/scripts/builder/build_toolchain.sh
source $(pwd)/scripts/builder/build_bash.sh

source $(pwd)/scripts/build_kernel.sh



source $(pwd)/scripts/builder/set_permissions.sh


### END IMPORT BUILDER FUNCTIONS ### END IMPORT BUILDER FUNCTIONS ### END IMPORT BUILDER FUNCTIONS ###


### EXPORT VARIABLES ### EXPORT VARIABLES ### EXPORT VARIABLES ### ###########
export PROJEKT_DIR=$(pwd)
export BUILDING=$(pwd)/work

export OUTPUT=$(pwd)/output

export BOOTFS=$(pwd)/work/bootfs
export ROOTFS=$(pwd)/work/rootfs

export LOG_DIR=$(pwd)/logs


### END EXPORT VARIABLES ### END EXPORT VARIABLES ### END EXPORT VARIABLES ###





### CREATES ROOTFS_DIR, BOOTFS_DIR & WORKING_DIR 
eco info "Creating: $ROOTFS, $BOOTFS, $BUILDING, $LOG_DIR"
log info "Creating: $ROOTFS, $BOOTFS, $BUILDING, $LOG_DIR"
sudo mkdir -p $ROOTFS $BOOTFS $BUILDING $LOG_DIR








welcome() {
    echo "======================================================="
    
    eco info "Das ROOTFS-Verzeichnis ist: $ROOTFS"

}



build_rootfs() {

    eco info "Creating ROOTFS's - Directorys!!!... .. .\n $ROOTFS/{bin,sbin,etc/{init.d,udev/{rules.d},cron.d},lib,lib64,usr/{bin,lib,local,include,sbin},home,mnt,dev,proc,sys,root,tmp,var}"
   
    mkdir -p $ROOTFS/{bin,sbin,etc/{init.d,udev/{rules.d},cron.d,network},lib,lib64,usr/{src,bin,lib,include,sbin},home,opt,mnt,dev,proc,sys,root,tmp,var}

    chmod 1777 $ROOTFS/tmp  

    eco info "Creating: DEVICES !!!"
    create_devices
    
    eco info "Creating: INIT !!!"
    create_init
    
    eco info "Creating: INITTAB !!!"
    create_inittab;

    eco info "Creating: FSTAB !!!"
    create_fstab;

    eco info "Creating: init.d/rcS !!!"
    create_initd;

    eco info "Creating: HOSTNAME !!!"
    create_hostname

    eco info "Creating: INTERFACES !!!"
    create_ifaces

    eco info "Creating: HOSTS !!!"
    create_hosts

    eco info "Creating: PASSWD !!!"
    create_passwd

    eco info "Creating: GROUPS !!!"
    create_group

    eco info "Creating: SHADOW !!!"
    create_shadow

    eco info "Creating: MOTD !!!" 
    create_motd
    
    eco info "Creating: RESOLV !!!"
    create_resolv

    eco info "Creating: PROFILE !!!"
    create_profile

    eco info "Creating: LD.SO.CONF !!!"
    create_ldsoconf

    # eco info "Creating: RC.LOCAL !!!"
    # create_rclocal
    # create_udev
    # create_cronjob


}










initialize() {
   # PROCESSES={build_rootfs,build_busybox,build_gmp,build_mpfr,build_mpc,build_gcc,build_glibc,build_zlib,build_db,build_toolchain_rpi,build_toolchain,build_bash,build_rpm,build_opkg,set_permissions}
    
    welcome;

    build_rootfs;
    sleep 2;
    build_busybox;
    sleep 2;
    build_libarys;
    # sleep 2;
    # build_gmp;
    # sleep 2;
    # build_mpfr;
    # sleep 2;
    # build_mpc;
    # sleep 2;
    # build_gcc;
    # sleep 2;
    # build_glibc;
    # sleep 2;
    # build_zlib;
    # sleep 2;
    # build_db;
    # sleep 2;
    # build_toolchain_rpi;
    # sleep 2;
    # build_toolchain;
    # sleep 2;
    # build_bash;
    # sleep 2;
    # build_rpm;
    # sleep 2;
    # build_opkg;
    # sleep 2;
    set_permissions;
}


initialize;