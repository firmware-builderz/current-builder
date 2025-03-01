#!/bin/bash


set_permissions() {
    # RootFS Pfad
    # ROOTFS="$1"

    # if [ -z "$ROOTFS" ]; then
    #     eco info info "⚠  Nutzung: $0 /pfad/zum/rootfs"
    #     exit 1
    # fi

    eco info "🔧 Setze Berechtigungen im RootFS: $ROOTFS"

    # Wichtige Verzeichnisse mit Standardrechten
    eco info "📁 Setze Verzeichnis-Berechtigungen..."
    find $ROOTFS -type d -exec sudo chmod 755 {} \;
    find $ROOTFS -type d -exec sudo sudo chown root:root {} \;

        # Wichtige Systemdateien mit korrekten Berechtigungen
    eco info "🛡  Setze Systemdatei-Berechtigungen..."


    sudo chmod +x $ROOTFS/init

    # /etc Verzeichnis
    sudo chmod 755 $ROOTFS/etc
    sudo sudo chown root:root $ROOTFS/etc


    sudo chmod +x $ROOTFS/etc/init.d/rcS

    # /etc/passwd
    sudo chmod 644 $ROOTFS/etc/passwd
    sudo sudo chown root:root $ROOTFS/etc/passwd

    # /etc/group
    sudo chmod 644 $ROOTFS/etc/group
    sudo sudo chown root:root $ROOTFS/etc/group

    # /etc/shadow (sensibel)
    sudo chmod 600 $ROOTFS/etc/shadow
    sudo sudo chown root:root $ROOTFS/etc/shadow

    # /etc/gshadow (falls vorhanden)
    if [ -f "$ROOTFS/etc/gshadow" ]; then
        sudo chmod 600 $ROOTFS/etc/gshadow
        sudo sudo chown root:root $ROOTFS/etc/gshadow
    fi

    # /etc/hosts und /etc/hostname
    sudo chmod 644 $ROOTFS/etc/hosts
    sudo chmod 644 $ROOTFS/etc/hostname
    sudo sudo chown root:root $ROOTFS/etc/hosts
    sudo sudo chown root:root $ROOTFS/etc/hostname

    # Binaries ausführbar machen
    eco info "🚀 Setze Berechtigungen für Binaries..."

    find $ROOTFS/bin -type f -exec sudo chmod 755 {} \;
    find $ROOTFS/sbin -type f -exec sudo chmod 755 {} \;
    find $ROOTFS/usr/bin -type f -exec sudo chmod 755 {} \;
    find $ROOTFS/usr/sbin -type f -exec sudo chmod 755 {} \;

    # BusyBox prüfen und korrekt verlinken
    if [ -f "$ROOTFS/bin/busybox" ]; then
        sudo chmod 755 $ROOTFS/bin/busybox
        sudo sudo chown root:root $ROOTFS/bin/busybox

        # Symlink für /bin/sh setzen
        if [ ! -L "$ROOTFS/bin/sh" ]; then
            ln -sf /bin/busybox $ROOTFS/bin/sh
            eco info "🔗 Symlink /bin/sh -> /bin/busybox erstellt."
        fi
    else
        eco info "⚠  BusyBox nicht gefunden unter $ROOTFS/bin/busybox"
    fi

    # Devices-Verzeichnis
    eco info "🖧 Setze Rechte für /dev, /sys, /tmp und /proc..."
    sudo chmod 755 $ROOTFS/dev
    sudo chmod 755 $ROOTFS/proc
    sudo chmod 755 $ROOTFS/sys
    sudo chmod 1777 $ROOTFS/tmp

    # Wichtige Geräte-Dateien erstellen, falls sie fehlen
    if [ ! -e "$ROOTFS/dev/null" ]; then
        sudo mknod -m 666 $ROOTFS/dev/null c 1 3
    fi

    if [ ! -e "$ROOTFS/dev/console" ]; then
        sudo mknod -m 600 $ROOTFS/dev/console c 5 1
    fi

    # Abschluss
    eco info "✅ Berechtigungen erfolgreich gesetzt!"
}