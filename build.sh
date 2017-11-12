#!/bin/bash
set -euo pipefail

[[ $EUID -ne 0 ]] && (echo 'This script must be run as root'; exit 1)
musthave() { which $1 > /dev/null || (echo "Could not find $1!"; exit 1); }
musthave bc
musthave gcc
musthave hostname
musthave install
musthave lz4c
musthave make
musthave mksquashfs
musthave minijail0
musthave tar
musthave wget

mkdir -p cached
wget -cO cached/linux-4.13.2.tar.gz    https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.13.2.tar.gz
wget -cO cached/arch-2017.11.01.tar.gz https://mirror.csclub.uwaterloo.ca/archlinux/iso/2017.11.01/archlinux-bootstrap-2017.11.01-x86_64.tar.gz
wget -cO cached/idea-2017.2.5-n.tar.gz https://download.jetbrains.com/idea/ideaIU-2017.2.5-no-jdk.tar.gz

sha256sum -c sha256sums

./bkernel.sh
./broot.sh
./bdata.sh
