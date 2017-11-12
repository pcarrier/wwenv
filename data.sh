#!/bin/bash
set -euo pipefail

[[ -e /src/out/data.fs ]] && exit

mkdir -p /src/out
truncate -s 50G /src/out/data.fs
mkfs.ext4 -Ldata /src/out/data.fs
mount -o loop /src/out/data.fs /mnt/data
mkdir -p /mnt/data/home/{upper,workdir}
chown user: /mnt/data/home/upper
