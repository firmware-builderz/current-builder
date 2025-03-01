#!/bin/bash




create_init() {
    cat <<EOF > $ROOTFS/init
#!/bin/sh
# Minimales Init-Skript für das Raspberry Pi RootFS

# Mounten der wichtigsten Dateisysteme
# mount -t proc proc /proc
# mount -t sysfs sysfs /sys
# mount -t devtmpfs devtmpfs /dev
# mount -t tmpfs tmpfs /tmp

# Mounten der wichtigsten Dateisysteme
mount -t proc proc /proc || echo "Fehler beim Mounten von /proc" > /dev/console
mount -t sysfs sysfs /sys || echo "Fehler beim Mounten von /sys" > /dev/console
mount -t devtmpfs devtmpfs /dev || echo "Fehler beim Mounten von /dev" > /dev/console
mount -t tmpfs tmpfs /tmp || echo "Fehler beim Mounten von /tmp" > /dev/console


# Netzwerk starten (falls gewünscht)
# ifconfig eth0 up
# udhcpc -i eth0

# Starte die Shell
exec /bin/sh

EOF

chmod +x $ROOTFS/init

}




create_inittab() {
    cat > $ROOTFS/etc/inittab <<EOF
::sysinit:/bin/mount -t proc proc /proc || echo "Fehler beim Mounten von /proc" > /dev/console
::sysinit:/bin/mount -t sysfs sysfs /sys || echo "Fehler beim Mounten von /sys" > /dev/console
::sysinit:/bin/mount -t tmpfs tmpfs /tmp || echo "Fehler beim Mounten von /tmp" > /dev/console
::sysinit:/bin/mount -o bind /dev /dev
::sysinit:/bin/mount -o bind /dev/pts /dev/pts

# Optional Netzwerk starten (auskommentiert)
# ::sysinit:/sbin/ifconfig eth0 up
# ::sysinit:/sbin/udhcpc -i eth0

# Start der Shell, immer wieder neu starten
::respawn:-/bin/sh

# Neustart von init, falls erforderlich
::restart:/sbin/init

# CTRL+ALT+DEL ignorieren
::ctrlaltdel:/bin/echo "CTRL+ALT+DEL ignored"
EOF
}



create_initd() {
   cat <<EOF > $ROOTFS/etc/init.d/rcS
#!/bin/sh

# Minimales System-Startskript für Raspberry Pi RootFS

echo "Starte das System..."

# Mounten der wichtigsten Dateisysteme
echo "Mounten von /proc..."
mount -t proc none /proc || echo "Fehler beim Mounten von /proc" > /dev/console

echo "Mounten von /sys..."
mount -t sysfs none /sys || echo "Fehler beim Mounten von /sys" > /dev/console

echo "Mounten von /tmp..."
mount -t tmpfs none /tmp || echo "Fehler beim Mounten von /tmp" > /dev/console

echo "Mounten von /dev..."
mount -o bind /dev /dev

echo "Mounten von /dev/pts..."
mount -o bind /dev/pts /dev/pts

# Optional Netzwerk starten (auskommentiert)
# echo "Starte Netzwerk..."
# /etc/init.d/networking start

# Weitere Initialisierungen (z.B. Syslog starten)
# echo "Starte Syslog..."
# /etc/init.d/syslog start

# Loggen, dass der Start abgeschlossen ist
echo "Systemstart abgeschlossen."

# Starte die Konsole (Shell)
echo "Starte die Shell..."
exec /bin/sh
EOF

chmod +x $ROOTFS/etc/init.d/rcS
}



create_fstab() {
    cat <<EOF > $ROOTFS/etc/fstab
proc            /proc          proc      defaults        0      0
sysfs           /sys           sysfs     defaults        0      0
tmpfs           /tmp           tmpfs     defaults        0      0
/dev/mmcblk0p2  /              ext4      defaults        0      1
/dev/mmcblk0p1  /boot          vfat      defaults        0      2
EOF
}








create_hostname() {
    echo "blackzberry" > $ROOTFS/etc/hostname
}



create_ifaces() {
    cat <<EOF > $ROOTFS/etc/network/interfaces
# /etc/network/interfaces
# Netzwerkkonfiguration für ein statisches IP-Setup

auto lo
iface lo inet loopback

# iface eth0 inet dhcp

# Beispiel für statische IP-Konfiguration (optional)
iface eth0 inet static
address 192.168.178.100
netmask 255.255.255.0
gateway 192.168.178.1
EOF
}



create_hosts() {
    cat <<EOF > $ROOTFS/etc/hosts
# /etc/hosts
127.0.0.1   localhost
::1         localhost
192.168.178.100 blackzberry
EOF
}



create_profile() {
    cat <<EOF > $ROOTFS/etc/profile
# /etc/profile
export PS1='[\u@\h \W]\$ '
EOF
}



create_passwd() {
    cat > $ROOTFS/etc/passwd <<EOL
# /etc/passwd
root:x:0:0:root:/root:/bin/sh
EOL
}



create_group() {
    cat > $ROOTFS/etc/group <<EOL
# /etc/group
root:x:0:
EOL
}



create_shadow() {
    cat > $ROOTFS/etc/shadow <<EOL
# /etc/shadow
root:*:17535:0:99999:7:::
EOL
}



create_motd() {
    echo "Willkommen zum Minimal-Betriebssystem!" > $ROOTFS/etc/motd
}





create_resolv() {
    cat > $ROOTFS/etc/resolv.conf <<EOL
# /etc/resolv.conf
# DNS-Server-Konfiguration
nameserver 8.8.8.8
nameserver 8.8.4.4
EOL
}





create_devices() {
    sudo mknod -m 666 $ROOTFS/dev/console c 5 1
    sudo mknod -m 666 $ROOTFS/dev/tty c 5 0
    sudo mknod -m 666 $ROOTFS/dev/tty0 c 4 0
    sudo mknod -m 666 $ROOTFS/dev/tty1 c 4 1
    sudo mknod -m 666 $ROOTFS/dev/null c 1 3
    sudo mknod -m 666 $ROOTFS/dev/zero c 1 5
    sudo mknod -m 666 $ROOTFS/dev/ttyS0 c 4 64
    sudo mknod -m 666 $ROOTFS/dev/random c 1 8
    sudo mknod -m 666 $ROOTFS/dev/urandom c 1 9
    sudo mknod -m 666 $ROOTFS/dev/loop0 b 7 0
    sudo mknod -m 666 $ROOTFS/dev/ptmx c 5 2
    sudo mkdir -m 700 $ROOTFS/dev/pts
    sudo mknod -m 666 $ROOTFS/dev/pts/0 c 136 0
    sudo mkdir -m 1777 $ROOTFS/dev/shm
}




create_rclocal() {
    cat <<EOF > $ROOTFS/etc/rc.local
# /etc/rc.local
#!/bin/sh -e
# rc.local

# Hier können benutzerdefinierte Befehle hinzugefügt werden

exit 0
EOF
}





create_ldsoconf() {
    cat <<EOF > $ROOTFS/etc/ld.so.conf
# /etc/ld.so.conf
/usr/local/lib
EOF
}



create_rcd() {
    cat <<EOF > $ROOTFS/etc/init.d/networking
# /etc/init.d/networking
# Netzwerkkonfiguration starten

ifconfig eth0 up
dhclient eth0
EOF

}




create_udev() {
    cat <<EOF > $ROOTFS/etc/udev/rules.d/10-local.rules
# /etc/udev/rules.d/10-local.rules
KERNEL=="ttyS[0-9]", MODE="0666"
EOF
}



create_cronjob() {
    cat <<EOF > $ROOTFS/etc/cron.d/example
# /etc/cron.d/example
* * * * * root /usr/local/bin/example-script.sh
EOF
}