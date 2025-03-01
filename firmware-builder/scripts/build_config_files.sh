#!/bin/bash




create_init() {
    cat <<EOF > $ROOTFS/init
#!/bin/sh
# Minimales Init-Skript für das Raspberry Pi RootFS

# Mounten der wichtigsten Dateisysteme mit Fehlerüberprüfung
echo "Mounten der Dateisysteme..."
mount -t proc proc /proc || echo "$(date) Fehler beim Mounten von /proc" >> /var/log/boot.log
mount -t sysfs sysfs /sys || echo "$(date) Fehler beim Mounten von /sys" >> /var/log/boot.log
mount -t devtmpfs devtmpfs /dev || echo "$(date) Fehler beim Mounten von /dev" >> /var/log/boot.log
mount -t tmpfs tmpfs /tmp || echo "$(date) Fehler beim Mounten von /tmp" >> /var/log/boot.log

# Netzwerk starten (falls gewünscht und eth0 vorhanden)
echo "Starte Netzwerkdienste..."
ifconfig eth0 up || echo "$(date) Fehler beim Aktivieren von eth0" >> /var/log/boot.log
udhcpc -i eth0 || echo "$(date) Fehler bei der DHCP-Anforderung" >> /var/log/boot.log

# Optionale Netzwerkkonfiguration: Falls du eine statische IP willst, kannst du sie hier setzen:
# ifconfig eth0 192.168.1.100 netmask 255.255.255.0 || echo "$(date) Fehler bei der statischen IP-Konfiguration" >> /var/log/boot.log

# Optional: Start von Systemdiensten wie SSH, falls gewünscht
# echo "Starte SSH-Dienst..."
# /etc/init.d/ssh start

# Hostname setzen (optional, falls gewünscht)
echo "Setze Hostname auf 'blackzberry'..."
echo "blackzberry" > /etc/hostname
hostname "blackzberry" || echo "$(date) Fehler beim Setzen des Hostnamens" >> /var/log/boot.log

# Starte die Shell (oder den gewünschten Dienst)
echo "Starte Shell..."
exec /bin/sh

EOF
dl 2
log info "Change Permissions on File to 755..."
chmod +x $ROOTFS/init
dl 2
log info "Created: /init - File & Granted Permissions !!!"
}




create_inittab() {
    cat > $ROOTFS/etc/inittab <<EOF
::sysinit:/bin/mount -t proc proc /proc || echo "Fehler beim Mounten von /proc" > /dev/console
::sysinit:/bin/mount -t sysfs sysfs /sys || echo "Fehler beim Mounten von /sys" > /dev/console
::sysinit:/bin/mount -t tmpfs tmpfs /tmp || echo "Fehler beim Mounten von /tmp" > /dev/console
::sysinit:/bin/mount -t devtmpfs devtmpfs /dev || echo "Fehler beim Mounten von /dev" > /dev/console
::sysinit:/bin/mount -o bind /dev /dev
::sysinit:/bin/mount -o bind /dev/pts /dev/pts

# Netzwerk starten (auskommentiert für den Fall, dass es nicht benötigt wird)
::sysinit:/sbin/ifconfig eth0 up || echo "Fehler beim Aktivieren von eth0" > /dev/console
::sysinit:/sbin/udhcpc -i eth0 || echo "Fehler bei der DHCP-Anforderung" > /dev/console

# Start der Shell, immer wieder neu starten
::respawn:/bin/sh

# Neustart von init, falls erforderlich
::restart:/sbin/init

# CTRL+ALT+DEL ignorieren
::ctrlaltdel:/bin/echo "CTRL+ALT+DEL ignored"

EOF

dl 2

log info "Change Permissions on File to 755..."

chmod +x $ROOTFS/init

dl 2

log info "Created: /init - File & Granted Permissions !!!"

}



create_initd_rcs() {
   cat <<EOF > $ROOTFS/etc/init.d/rcS
#!/bin/sh
# rcS - Startskript für die Initialisierung von Systemdiensten

echo "Starte das System..."

# Funktion zum Mounten der wichtigsten Dateisysteme
mount_filesystems() {
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
}

# Funktion zum Konfigurieren des Netzwerks
configure_network() {
    echo "Starte Netzwerkdienste..."
    ifconfig eth0 up || echo "Fehler beim Aktivieren von eth0" > /dev/console
    udhcpc -i eth0 || echo "Fehler bei der DHCP-Anforderung" > /dev/console
}

# Funktion zum Synchronisieren der Zeit (optional)
configure_time() {
    # ntpd -qg || echo "Fehler bei der Zeit-Synchronisierung" > /dev/console
    # oder die Hardware-Uhr setzen (falls vorhanden)
    hwclock -s || echo "Fehler beim Setzen der Hardware-Uhr" > /dev/console
}

# Funktion zum Starten von Systemdiensten (SSH, Webserver, etc.)
start_ssh() {
    # Beispiel: SSH starten
    echo "Starte SSH-Dienst..."
    /etc/init.d/ssh start || echo "Fehler beim Starten von SSH" > /dev/console
}

# Weitere Dienste starten
start_additional_services() {
    # Beispiel: Webserver starten
    # echo "Starte Webserver..."
    # /etc/init.d/apache2 start || echo "Fehler beim Starten des Webservers" > /dev/console
}

# Funktion zum Starten der Konsole (Shell)
start_shell() {
    echo "Starte Shell..."
    exec /bin/sh
}

# Mounten der Dateisysteme
mount_filesystems

# Netzwerk konfigurieren
configure_network

# Zeit synchronisieren (optional)
configure_time

# Starte Dienste
start_ssh
start_additional_services

# Starte die Konsole (Shell)
start_shell

EOF

log info "Finished creating rcS!!!"
dl 2
log info "Grant Permissions!!!"

chmod +x $ROOTFS/etc/init.d/rcS
}



create_fstab() {
    cat <<EOF > $ROOTFS/etc/fstab
# Mounten des proc-Dateisystems
proc            /proc          proc      defaults        0      0

# Mounten des sysfs-Dateisystems
sysfs           /sys           sysfs     defaults        0      0

# Mounten des tmpfs-Dateisystems für temporäre Dateien
tmpfs           /tmp           tmpfs     defaults,noatime 0 0

# Mounten von /dev als tmpfs
tmpfs           /dev           tmpfs     defaults,noatime 0 0

# Mounten von /dev/pts für PTS (pseudoterminals)
devpts          /dev/pts       devpts    defaults,noatime 0 0

# Mounten der Root-Partition (ext4)
# Optimierungen: noatime, nodiratime für bessere Performance
/dev/mmcblk0p2  /              ext4      defaults,noatime,nodiratime 0 1

# Mounten der Bootpartition (vfat)
# Optimierungen: noatime, um unnötige Lesezugriffe zu vermeiden
/dev/mmcblk0p1  /boot          vfat      defaults,noatime 0 2

# Optional: Mounten von /dev/shm für Shared Memory
tmpfs           /dev/shm       tmpfs     defaults 0 0

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
#!/bin/sh -e
# rc.local

# Beispiel: Blinken einer LED an GPIO 17
echo "1" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio17/direction
while true; do
    echo "1" > /sys/class/gpio/gpio17/value
    sleep 1
    echo "0" > /sys/class/gpio/gpio17/value
    sleep 1
done &

exit 0

EOF
}





create_ldsoconf() {
    cat <<EOF > $ROOTFS/etc/ld.so.conf
# /etc/ld.so.conf
/usr/local/lib
EOF
}



create_networking() {
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