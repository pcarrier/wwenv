#!/bin/bash
set -euo pipefail

mkdir -p cached/guest/pacman/pkg

rm -rf root
mkdir -p root/idea
tar xzf cached/arch-2017.11.01.tar.gz -C root      --strip-components=1
tar xzf cached/idea-2017.2.5-n.tar.gz -C root/idea --strip-components=1

./chroot.sh \
/bin/bash /src/root.sh

mkdir -p out
mksquashfs root out/root.fs -comp lz4 -Xhc -noappend
