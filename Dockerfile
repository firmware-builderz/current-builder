# syntax=docker/dockerfile:experimental 

# Basis-Image mit den notwendigen Tools
FROM debian:latest

# Installiere Abhängigkeiten für den Build
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    bc \
    u-boot-tools \
    flex \
    bison \
    libssl-dev \
    device-tree-compiler \
    qemu-user-static \
    && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /firmware-builder

# Skript für den Build-Prozess kopieren
COPY . .

# Sicherstellen, dass das Skript ausführbar ist
RUN chmod +x /firmware-builder/firmware-builder.sh

# Standardbefehl beim Start
CMD ["/firmware-builder/firmware-builder.sh"]
