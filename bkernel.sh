#!/bin/bash
set -euo pipefail

mkdir -p cached/kbuild

[[ ! -d cached/linux-4.13.2 ]] && tar xzf cached/linux-4.13.2.tar.gz -C cached

cp kconfig cached/kbuild/.config

(
cd cached/linux-4.13.2
make -j4 O=../kbuild oldconfig
make -j4 O=../kbuild bzImage
)

cp cached/kbuild/arch/x86/boot/bzImage out/bzImage
cp cached/kbuild/arch/x86/boot/compressed/vmlinux.bin out/bzImage
