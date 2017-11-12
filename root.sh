#!/bin/bash

set -euo pipefail

export HOME=/root

cp -R /src/etc/* /etc/
chown -R root: /etc
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
ln -s /etc/systemd/system/home.mount /etc/systemd/system/multi-user.target.wants/home.mount
ln -s /dev/null /etc/tmpfiles.d/man-db.conf
ln -s /dev/null /etc/tmpfiles.d/var.conf

pacman-key --init
pacman-key --populate archlinux
pacman-key --recv-keys 1EDDE2CDFC025D17F6DA9EC0ADAE6AD28A8F901A
pacman-key --lsign-key 1EDDE2CDFC025D17F6DA9EC0ADAE6AD28A8F901A

pacman -F --refresh
pacman -S --refresh
pacman -S --noconfirm procps-ng \
gzip sed # used by locale-gen during glibc upgrade

pkill gpg-agent
pkill dirmngr

pacman -S --noconfirm --sysupgrade

pacman -S --noconfirm --needed --asdeps \
libglvnd \
libx264 \
jshon \
ttf-croscore

pacman -S --noconfirm --needed \
adwaita-icon-theme \
aria2 \
base-devel \
bc \
ctags \
curl \
dfc \
docker \
firejail \
git \
go \
ltrace \
iproute2 \
iputils \
man-db \
man-pages \
mosh \
most \
mpv \
mtr \
nzbget \
openssh \
python \
qemu-headless \
ripgrep \
ruby \
rsync \
squashfs-tools \
strace \
sublime-text \
sway \
tk \
tig \
time \
traceroute \
tmux \
unrar \
unzip \
vim \
xorg-server-xwayland \
zsh


printf 'PKGEXT=.pkg.tar\nSRCEXT=.src.tar' >> /etc/makepkg.conf
curl -o apc "https://raw.githubusercontent.com/oshazard/apacman/master/apacman"

bash ./apc -S --noconfirm \
apacman \
direnv \
jdk8

useradd \
  --shell /usr/bin/zsh \
  --groups wheel \
  --home-dir /home \
  --no-create-home user
passwd -d user

mkdir -p /mnt/base /mnt/data
cp -r /src/home /mnt/base/home
chown -R user: /home /mnt/base/home

rm -rf \
/apc \
/etc/issue \
/etc/systemd/system/multi-user.target.wants/getty@* \
/etc/systemd/system/getty.target.wants/* \
/etc/systemd/user/sockets.target.wants/* \
/var/log
