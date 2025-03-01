#!/bin/bash 



build_busybox() {
    URL="https://github.com/mirror/busybox.git"

    eco info "BUILDING: BUSYBOX!!!"
    sleep 1;
    
    cd $BUILDING

    if [ ! -d busybox ]; then
        eco info "CLONING BUSYBOX REPO..."
        sleep 1;
        git clone --depth=1 $URL
    fi

    cd busybox

    sleep 1;

    
    log info "Configuring BUSYBOX..."
    make defconfig

    log info "Copying busybox defconfig !!!"
    if [ -f "$BUILDER/configs/busybox/.config" ]; then
        eco info "USING CUSTOM CONFIG..."
        sleep 1;
        cp "$BUILDER/configs/busybox/.config" .config
    fi


    sleep 1;
    log info "BUILDING BUSYBOX..."
    make -j$(nproc)

    sleep 1;
    log info "Installing BUSYBOX..."
    make CONFIG_PREFIX=$ROOTFS install

    sleep 1;
    log info "Fixing Busybox binaries..."

    cd $ROOTFS/bin
    for cmd in $(../bin/busybox --list); do ln -s busybox $cmd; done
    cd $BUILDING

    sleep 1;
    log succ "BUSYBOX BUILD SUCCESSFULLY!!!"
}


