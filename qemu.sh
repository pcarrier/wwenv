#!/bin/bash
stty intr '^]'
qemu-system-x86_64 \
-enable-kvm \
-kernel out/bzImage \
-display none \
-chardev stdio,id=virtiocon0 \
-device virtio-serial \
-device virtconsole,chardev=virtiocon0 \
-drive file=out/root.fs,if=virtio,format=raw,readonly=on \
-drive file=out/data.fs,if=virtio,format=raw,readonly=off \
"$@"
stty sane
