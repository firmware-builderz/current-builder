

```sh
mkdir -p rootfs/{bin,sbin,etc,proc,sys,dev,lib,usr}
cd rootfs



# Busybox
make defconfig
make CONFIG_STATIC=y
make install

cp -a _install/* rootfs/


```

# init script
```sh
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs devtmpfs /dev
exec /bin/sh


chmod +x rootfs/init

```

# ROOTFS in ext4 Umwandeln
```sh
dd if=/dev/zero of=rootfs.ext4 bs=1M count=128
mkfs.ext4 rootfs.ext4
mkdir /mnt/rootfs
sudo mount rootfs.ext4 /mnt/rootfs
sudo cp -a rootfs/* /mnt/rootfs/
sudo umount /mnt/rootfs
```


# FLash Images

```sh
# Partitionstabelle erstellen (erste Partition FAT32, zweite EXT4)
sudo parted /dev/sdX --script mklabel msdos
sudo parted /dev/sdX --script mkpart primary fat32 1MiB 256MiB
sudo parted /dev/sdX --script mkpart primary ext4 256MiB 100%

# Dateisysteme erstellen
sudo mkfs.vfat /dev/sdX1
sudo mkfs.ext4 /dev/sdX2

# Partitionen mounten und Dateien kopieren
mkdir -p /mnt/{boot,rootfs}
sudo mount /dev/sdX1 /mnt/boot
sudo mount /dev/sdX2 /mnt/rootfs

sudo cp -r boot/* /mnt/boot/
sudo cp -r rootfs/* /mnt/rootfs/

sudo umount /mnt/boot /mnt/rootfs
sync
```