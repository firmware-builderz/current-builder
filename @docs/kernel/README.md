Um **wichtige Kernel-Module** auf dein **RootFS für den Raspberry Pi 5** zu installieren, folge dieser Anleitung:  

---

## **📌 1. Kernel-Module kompilieren**
Falls du nicht bereits Kernel-Module hast, musst du sie aus den offiziellen Raspberry Pi Kernel-Quellen kompilieren.

### **1.1 Raspberry Pi Kernel-Quellen klonen**
Falls du den Kernel selbst baust, klone zuerst das Repository:

```bash
git clone --depth=1 https://github.com/raspberrypi/linux.git -b rpi-6.6.y
cd linux
```
📌 **Wähle den neuesten Raspberry Pi 5 Kernel-Branch (z. B. `rpi-6.6.y`)**.

### **1.2 Kernel-Konfiguration für Module vorbereiten**
Lade die Standardkonfiguration für den Raspberry Pi 5:

```bash
KERNEL=kernel8
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2712_defconfig
```

Falls du dein eigenes Kernel-Config-File nutzt, stelle sicher, dass **Module aktiviert** sind (`CONFIG_MODULES=y`).

### **1.3 Kernel-Module kompilieren**
```bash
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules
```

---

## **📌 2. Kernel-Module ins RootFS installieren**
Jetzt müssen die Kernel-Module ins **RootFS** kopiert werden.

### **2.1 Installiere die Module in ein temporäres Verzeichnis**
```bash
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=~/modules modules_install
```
Das installiert die Module nach `~/modules/lib/modules/`.

### **2.2 RootFS mounten**
Falls dein RootFS als Image (`rootfs.ext4`) vorliegt, **mounte** es zuerst:

```bash
sudo mount rootfs.ext4 /mnt
```

Falls dein RootFS auf einer SD-Karte ist:
```bash
sudo mount /dev/mmcblk0p2 /mnt
```

### **2.3 Kopiere die Kernel-Module**
```bash
sudo cp -a ~/modules/lib/modules/$(make kernelrelease) /mnt/lib/modules/
```

Falls du die Kernel-Version nicht kennst, kannst du sie herausfinden mit:

```bash
make kernelrelease
```

Nun `sync` ausführen, um sicherzustellen, dass alle Daten geschrieben wurden:

```bash
sync
```

### **2.4 RootFS aushängen**
```bash
sudo umount /mnt
```

---

## **📌 3. Prüfen, ob die Module richtig installiert sind**
Nach dem Booten des Raspberry Pi 5 kannst du prüfen, ob die Module geladen wurden:

```bash
ls /lib/modules/
```

Oder checke geladene Module mit:

```bash
lsmod
```

Falls ein wichtiges Modul fehlt, kannst du es manuell laden:

```bash
modprobe <modulname>
```

Falls **`modprobe` fehlt**, installiere BusyBox mit `CONFIG_FEATURE_MODUTILS=y`, damit `modprobe` verfügbar ist.

---

## **📌 4. Welche Module sind für den Raspberry Pi 5 wichtig?**
### **4.1 Minimal erforderliche Kernel-Module für das RootFS**
- **Speicherkarten-Unterstützung (SD-Karte)**  
  - `mmc_block.ko` (SD-Karten-Treiber)  
  - `sdhci.ko` (SD-Host-Controller)  

- **Dateisysteme**  
  - `ext4.ko` (Falls RootFS auf ext4 basiert)  
  - `vfat.ko` (Falls `/boot` eine FAT32-Partition ist)  

- **Netzwerk (Falls Ethernet benötigt wird)**  
  - `bcmgenet.ko` (Ethernet-Treiber für Raspberry Pi 5)  
  - `usbnet.ko` (Falls USB-Ethernet-Adapter verwendet wird)  

- **USB-Unterstützung (Falls USB-Geräte verwendet werden)**  
  - `xhci-hcd.ko` (USB 3.0 Unterstützung)  
  - `usb_storage.ko` (Für USB-Sticks oder Festplatten)  

- **Serielle Konsole (Falls UART Debug verwendet wird)**  
  - `serial_core.ko`  
  - `uart-pl011.ko` (PL011 UART-Treiber für Raspberry Pi)  

Falls du **Wi-Fi oder Bluetooth** nutzt:
- `cfg80211.ko`
- `brcmfmac.ko` (Broadcom Wi-Fi für Raspberry Pi)
- `btusb.ko` (Bluetooth über USB)

Falls ein Modul nicht automatisch geladen wird, kannst du es zur **`/etc/modules`** Datei hinzufügen:

```bash
echo "bcmgenet" >> /etc/modules
echo "mmc_block" >> /etc/modules
```

---

## **✅ Fazit**
1. **Kernel-Module mit `make modules && make modules_install` kompilieren**  
2. **Module ins RootFS kopieren (`/lib/modules/$(uname -r)/`)**  
3. **RootFS mounten, Module kopieren & wieder aushängen**  
4. **Booten & `lsmod` prüfen, ob die Module geladen wurden**  

Falls du ein **statisches RootFS** möchtest, kannst du die meisten Module direkt in den Kernel integrieren (`CONFIG_*=y`). 🎯