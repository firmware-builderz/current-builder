#!/bin/bash
# build_libarys.sh


build_libarys() {

    cd $ROOTFS/usr/src
    
    log info "Downlading Libarys!!!"
    wget https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz
    wget https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz
    wget https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
    wget https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2
    wget http://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz
    wget https://ftp.gnu.org/gnu/make/make-4.3.tar.gz
    wget https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.gz
    wget https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz
    wget https://ftp.gnu.org/gnu/libc/glibc-2.34.tar.gz



    log info "Installing GMP"
    tar -xf gmp-6.2.1.tar.xz && cd gmp-6.2.1
    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc) && make install DESTDIR=$ROOTFS
    cd ..

    log info "Installing MPFR!!!"
    tar -xf mpfr-4.2.1.tar.xz && cd mpfr-4.2.1
    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc) && make install DESTDIR=$ROOTFS
    cd ..

    log info "Installing MPC!!!"
    tar -xf mpc-1.3.1.tar.gz && cd mpc-1.3.1
    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc) && make install DESTDIR=$ROOTFS
    cd ..

    log info "Installing ISL!!!"
    tar -xf isl-0.24.tar.bz2 && cd isl-0.24
    ./configure --prefix=/usr --host=aarch64-linux-gnu
    make -j$(nproc) && make install DESTDIR=$ROOTFS
    cd ..

    log info "Installing GCC!!!"
    tar -xf gcc-10.2.0.tar.xz && cd gcc-10.2.0
    ./configure --prefix=/usr --host=aarch64-linux-gnu --disable-shared --enable-static
    make -j$(nproc)
    make install DESTDIR=$ROOTFS
    cd ..

    log info "Installing Make!!!"
    tar -xvzf make-4.3.tar.gz && cd make-4.3
    ./configure --host=aarch64-linux-gnu --prefix=/usr --bindir=/usr/bin
    make
    make DESTDIR=$ROOTFS install
    cd ..

    log info "Installing Libtool!!!"
    tar -xvzf libtool-2.4.6.tar.gz && cd libtool-2.4.6
    ./configure --host=aarch64-linux-gnu --prefix=/usr --bindir=/usr/bin
    make
    make DESTDIR=$ROOTFS install
    cd ..

    log info "Installing Bash!!!"
    tar -xvzf bash-5.1.tar.gz && cd bash-5.1
    ./configure --host=aarch64-linux-gnu --prefix=/usr --bindir=/usr/bin
    make
    make DESTDIR=$ROOTFS install
    cd ..

    log info "Installing Glibc!!!"
    tar -xvzf glibc-2.34.tar.gz && cd glibc-2.34
    mkdir build
    cd build
    ../configure --prefix=/usr --host=aarch64-linux-gnu --enable-static --disable-shared
    make -j$(nproc)
    make DESTDIR=$ROOTFS install
    cd ../..


}