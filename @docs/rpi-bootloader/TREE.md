```md

/boot/
│── config.txt           # Boot-Konfiguration (Kernel, GPU, Boot-Optionen)
│── cmdline.txt          # Kernel-Boot-Parameter
│── start4.elf           # Firmware-Datei (GPU & Bootcode)
│── fixup4.dat           # Zusätzliche Firmware-Datei
│── kernel8.img          # Der Linux-Kernel für ARM64
│── bcm2712-rpi-5b.dtb   # Device Tree für Raspberry Pi 5
│── overlays/            # Device Tree Overlays (Hardware-Erweiterungen)
│── initramfs-linux.img  # (Optional) Initramfs für Treiber vor dem RootFS
```