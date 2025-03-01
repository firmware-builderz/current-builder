#!/bin/bash


# Author:   hexzhen3x7
# Version:  0.1a
# Date:     2023-06-16 
# Time:     09:32 O'clock
# Email:    hexzhen3x7@gmail.com
# Purpose:  Build essential packages for a cross-compilation environment on Raspberry Pi 4
# Description: This is a simple package download & install script!""







build_libtool() {
    log info "Building libtool..."
    cd $PACKAGES

    tar xvf libtool*
    cd libtool*

    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}


build_python() {
    log info "Building Python..."
    cd $PACKAGES

    tar xvf Python*
    cd Python*

    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}


build_ncurses() {
    log info "Building NCurses..."
    cd  $PACKAGES

    tar xvf ncurses*
    cd ncurses*

    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc)
    make install DESTDIR=$ROOTFS

}



build_cmake() {
    cd $PACKAGES
    log info "Building CMake.... .... .. ."

    tar xvf cmake*
    cd cmake*

    ./bootstrap --prefix=/usr
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}


build_openssl() {
    log info "Building OpenSSL"
    cd $PACKAGES
    
    tar xvf openssl*
    cd openssl*

    ./config --prefix=/usr --openssldir=/etc/ssl
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}


build_gmp() {
    cd $PACKAGES
    log info "Building GMP.... .... .. ."

    tar xvf gmp-6.2.1.tar.xz
    cd gmp-6.2.1

    ./configure --prefix=/usr
    make 
    sudo make install
}





build_mpc() {
    cd $PACKAGES
    log info "Building MPC.... .... .. ."

    tar xvf mpc-1.2.1.tar.gz
    cd mpc-1.2.1

    ./configure --prefix=/usr
    make
    sudo make install
}
    


build_make() {
    log info "Building Make.... .... .. ."
    cd $PACKAGES

    tar xvf make*
    cd make*

    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}




build_gcc() {
    log info "Building GCC.... .... .. ."
    cd $PACKAGES

    tar xvf gcc-13.2.0*
    cd gcc-*
    mkdir build && cd build

    ../configure --prefix=/usr --host=aarch64-linux-gnu --enable-languages=c,c++ --disable-multilib
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}




build_binutils() {
    log info "Building Binutils.... .... .. ."
    cd $PACKAGES

    tar xvf binutils-2.42.tar.xz
    cd binutils-2.42
    mkdir build && cd build

    ../configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc)
    make install DESTDIR=$ROOTFS

}



build_glibc() {
    log info "Building Glibc.... .... .. ."
    cd $PACKAGES
    tar xvf glibc-2.39.tar.gz

    cd glibc-2.39
    mkdir build && cd build

    ../configure --prefix=/usr --host=aarch64-linux-gnu --disable-multi-arch
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}



build_zlib() {
    log info "Installing Zlib!!!"
    cd $PACKAGES

    tar xvf libtool*
    cd libtool*

    ./configure --prefix=/usr
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}



build_pkconfig() {
    log info "Installing PKConfig!!!"
    cd $PACKAGES

    tar xvf pkg-config*
    cd pkg-config*
    
    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
}





download() {
    cd $PACKAGES
    local url=$1
    local filename=$(basename "$url")

    if [ -f "$filename" ]; then
        log warn "[✔] $filename bereits vorhanden, überspringe Download."
    else
        log info "[↓] Lade $filename herunter..."
        wget --quiet --show-progress "$url"
    fi
}




# URLs der Abhängigkeiten
declare -A packages=(
    ["glibc"]="http://ftp.gnu.org/gnu/libc/glibc-2.39.tar.gz"
    ["zlib"]="https://zlib.net/zlib-1.3.1.tar.gz"
    ["ncurses"]="https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.4.tar.gz"
    ["binutils"]="http://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz"
    ["gmp"]="https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz"
    ["mpfr"]="https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz"
    ["mpc"]="https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz"
    ["gcc"]="http://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
    ["make"]="http://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz"
    ["cmake"]="https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7.tar.gz"
    ["openssl"]="https://www.openssl.org/source/openssl-3.2.1.tar.gz"
    ["libtool"]="http://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz"
    ["pkg-config"]="https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
    ["python"]="https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tgz"
    ["gcc"]="http://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz"
    ["gmp"]="https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
    ["mpfr"]="https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.xz"
    ["mpc"]="https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"
)

get_packages() {
    log info "[🔧] Starte den Download der Pakete..."
    for key in "${!packages[@]}"; do
        download "${packages[$key]}"
    done

    log succ "[✔] Alle Abhängigkeiten wurden erfolgreich heruntergeladen!"
}
