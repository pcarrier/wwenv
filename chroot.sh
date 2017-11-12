#!/bin/bash
exec minijail0 -p -T static \
-P $PWD/root \
-b /dev,/dev \
-b /proc,/proc \
-b /sys,/sys \
-b $PWD,/src,1 \
-b $PWD/cached/guest,/var/cache,1 \
"$@"
