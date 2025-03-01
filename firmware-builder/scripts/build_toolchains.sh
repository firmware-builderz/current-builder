#!/bin/bash



build_toolchain_rpi() {
    DATEI="cross-gcc-14.2.0-pi_64.tar.gz"
    URL="https://deac-fra.dl.sourceforge.net/project/raspberry-pi-cross-compilers/Bonus%20Raspberry%20Pi%20GCC%2064-Bit%20Toolchains/Raspberry%20Pi%20GCC%2064-Bit%20Cross-Compiler%20Toolchains/Bookworm/GCC%2014.2.0/cross-gcc-14.2.0-pi_64.tar.gz"
    
    eco info "BUILDING: RPI TOOLCHAIN!!!"
    cd $BUILDING
    sleep 1;

    if [ -e "$DATEI" ]; then
        eco "Die Datei $DATEI existiert bereits."
        sleep 1;
    else
        eco warning "Die Datei $DATEI existiert noch nicht."
        sleep 1;
        eco info "Downloading Toolchain..."
        wget $URL
    fi
    
    eco info "Extracting Toolchain..."
    tar xvzf cross-gcc-14.2.0-pi_64.tar.gz -C $ROOTFS/opt
    sleep 1;
    echo "export PATH=\$ROOTFS/opt/cross-pi-gcc-14.2.0-64/bin:\$PATH" >> $ROOTFS/etc/profile
    cd $BUILDING
}



build_toolchain() {
    TOOLCHAIN_DIR=$ROOTFS/usr/local
    TOOLCHAIN_URL="https://releases.linaro.org/archive/20.10/components/toolchain/binaries/arm64-linux/gcc-linaro-10.3-2021.07-x86_64_aarch64-linux-gnu.tar.xz"

    eco info "BUILDING: RPI TOOLCHAIN!!!"
    log info "BUILDING: RPI TOOLCHAIN!!!"
    cd $BUILDING
    
    if [ -e "gcc-linaro-10.3-2021.07-x86_64_aarch64-linux-gnu.tar.xz" ]; then
        eco info "Die Datei gcc-linaro-10.3-2021.07-x86_64_aarch64-linux-gnu.tar.xz existiert bereits."
    else
        eco warning "Die Datei gcc-linaro-10.3-2021.07-x86_64_aarch64-linux-gnu.tar.xzexistiert noch nicht."
        eco info "Lade die Cross-Compiling Toolchain herunter..."
        wget $TOOLCHAIN_URL -P /tmp
    fi

    

    eco info "Entpacke die Toolchain..."
    tar -xvzf /tmp/gcc-linaro-*.tar.xz -C $TOOLCHAIN_DIR

    eco info "Setze die Berechtigungen..."
    chmod -R 755 $TOOLCHAIN_DIR/gcc-linaro-*

    eco info "Füge die Toolchain dem PATH hinzu..."
    echo "export PATH=$TOOLCHAIN_DIR/gcc-linaro-*/bin:\$PATH" >> $ROOTFS/etc/profile
    eco info "Cross-Toolchain wurde erfolgreich installiert und der PATH aktualisiert!"
}


