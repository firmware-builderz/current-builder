
build_inittab() {
    cat <<EOF > $ROOTFS/etc/inittab

# /etc/inittab - Konfiguration für den init-Prozess
# Dieser File definiert den Standard-Runlevel und die Terminal-Startoptionen

# Setze den Standard-Runlevel
id:3:initdefault:

# Serielles Terminal (Konsole)
1:2345:respawn:/sbin/getty 115200 ttyAMA0

# Virtuelle Konsolen (tty1 bis tty6)
1:2345:respawn:/sbin/getty 115200 tty1
2:2345:respawn:/sbin/getty 115200 tty2
3:2345:respawn:/sbin/getty 115200 tty3
4:2345:respawn:/sbin/getty 115200 tty4
5:2345:respawn:/sbin/getty 115200 tty5
6:2345:respawn:/sbin/getty 115200 tty6

# Wiederherstellung der Konsole, falls getty nicht verfügbar ist
# Die Konsole wird in jedem Runlevel neu gestartet.
EOF

eco info "Grant Permission to: /etc/inittab !!!"
log info "Grant Permission to: /etc/inittab !!!"
chmod +x $ROOTFS/etc/inittab

}



create_fstab() {
    eco info "Creating fstab !!!"
    log info "Creating fstab !!!"

    cat > $ROOTFS/etc/fstab <<EOF
/dev/root    /        ext4    defaults,noatime,nodiratime 0 0
proc            /proc       proc    defaults        0 0
sysfs           /sys        sysfs   defaults        0 0
tmpfs           /tmp        tmpfs   defaults        0 0
devpts          /dev/pts    devpts  defaults        0 0
EOF

    eco info "Granting Permissions on: /etc/fstab !!!"
    log info "Granting Permissions on: /etc/fstab !!!"
    chmod +x /etc/fstab 

    eco success "Creating: /etc/fstab Finished!!!"
    log succ "Creating: /etc/fstab Finished!!!"
}


