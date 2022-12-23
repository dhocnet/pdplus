#!/data/data/com.termux/files/usr/bin/bash
#
# Slackware installer for Termux
#
# Oleh          : mongkeelutfi
# Email         : mongkee.lutfi@gmail.com
# Blog          : https://blog.dhocnet.work
# Kode sumber   : https://github.com/dhocnet/termux-slackwareinstall
#
# Start in Desember 2022

# activating text formatting
shopt -s xpg_echo

# setting up vatiables
HOME=/data/data/com.termux/files/home
SLACKWARE=$HOME/slackware
PKGTMP=$SLACKWARE/tmp/pkg
SETUP=$SLACKWARE/tmp/setup
PKGURI="https://mirrors.slackware.com/slackwarearm/slackware-curent"
INSTALLPKG_DL="https://github.com/dhocnet/termux-slackwareinstall/raw/master"

# MINIROOT PKG BY ALIEN BOB 
PKG_MINI="a/aaa_base
a/aaa_elflibs
a/aaa_terminfo
a/acl
a/attr
a/bash
a/tar
a/bin
a/btrfs-progs
a/bzip2
a/coreutils
a/dbus
a/dcron
a/devs
a/dialog
a/e2fsprogs
a/ed
a/etc
a/file
a/findutils
a/hostname
a/hwdata
a/lbzip2
a/less
a/gawk
a/gettext
a/getty-ps
a/glibc-solibs
a/glibc-zoneinfo
a/gptfdisk
a/grep
a/gzip
a/jfsutils
a/inotify-tools
a/kmod
a/lrzip
a/lzip
a/lzlib
a/pkgtools
a/procps-ng
a/reiserfsprogs
a/shadow
a/sed
a/sysklogd
a/usbutils
a/util-linux
a/which
a/xfsprogs
a/xz
ap/groff
ap/man-db
ap/man-pages
ap/nano
ap/slackpkg
d/perl
d/python
d/python-pip
d/python-setuptools
n/openssl
n/ca-certificates
n/gnupg
n/lftp
n/libmnl
n/network-scripts
n/nfs-utils
n/ntp
n/iputils
n/net-tools
n/iproute2
n/openssh
n/rpcbind
n/libtirpc
n/rsync
n/telnet
n/traceroute
n/wget
n/wpa_supplicant
n/wireless-tools
l/lzo
l/libnl3
l/libidn
l/libunistring
l/mpfr
l/ncurses
l/pcre"

SETUP_MULAI () {
    clear
    # konfirmasi instalasi paket yang dibutuhkan oleh slackware
    # pkgtools
    echo "Anda membutuhkan beberapa program lain untuk
menyelesaikan instalasi Slackware-current ARM. Yaitu:

    1) wget
    2) coreutils
    3) proot
    4) util-linux
    5) grep
    6) Dialog
    7) lzip
"
    read -p 'Install program [Y/n]? ' ins_y
    if [ $ins_y = "n" ]
    then
        SETUP_BATAL
    else
        SETUP_TERMUX
    fi
}

SETUP_BATAL () {
    clear
    echo "Istalasi Slackware dibatalkan!\n"
}

SETUP_TERMUX () {
    clear
    echo "Menginstal program yang dibutuhkan ...\n"
    apt -y upgrade && apt -y install grep coreutils lzip proot tar wget util-linux dialog
    sleep 1
    SETUP_SELECT
}

SETUP_SELECT () {
    clear
    echo "PILIH JENIS INSTALASI
    
    1) Minimalis - dl: 76MB/inst: 350MB+
    2) Penuh tanpa X - dl: 851MB/inst: 5.8GB+
    "
    read -p 'Pilihan (default: 1) [1/2]: ' pilih_tipe
    if [ ! -d $PKGTMP ]
    then
        mkdir -p $PKGTMP
        if [ ! -d $SETUP ]
        then
            mkdir -p $SETUP
        fi
    fi
    if [ $pilih_tipe = "2" ]
    then
        INSTALL_DEVEL
    else
        INSTALL_DEFAULT
    fi
}

INSTALL_DEFAULT () {
    clear
    echo "Mengunduh program installer: installpkg"
    wget -c -t 0 -P $SETUP/ -q --show-progress $INSTALLPKG_DL/installpkg
    chmod +x $SETUP/installpkg
    echo "OK.\n"
    echo "Mengunduh paket dasar miniroot:"
    sleep 1
    for PKG_TODL in $PKG_MINI ; do
        wget -c -t 0 -T 10 -w 5 -P $PKGTMP -q --show-progress $PKGURI/slackware/$PKG_TODL-*.txz
    done
    echo "OK.\n"
    echo "Memasang sistem dasar Slackware miniroot ..."
    sleep 2
    # buang pesan error yang timbul karena perintah perintah dari installscript doinst.sh
    # biasanya masalah yang timbul karena kesalahan chown fulan.binfulan atau perintah chroot
    # yang tidak terdapat pada termux environment
    $SETUP/installpkg --terse --root $SLACKWARE/ $PKGTMP/*.txz 2> /dev/null
    INSTALL_STATER
}

INSTALL_DEVEL () {
    clear
    PKG_DEVDIR="a ap d e l n t"
    echo "Mengunduh program installer: installpkg, upgradepkg, removepkg"
    wget -c -t 0 -P $SETUP/ -q --show-progress $INSTALLPKG_DL/{installpkg,removepkg,upgradepkg}
    echo "OK.\n\nMengunduh paket penuh:"
    chmod +x $SETUP/{installpkg,removepkg,upgradepkg}
    sleep 1
    for PKG_DEVDL in $PKG_DEVDIR ; do
        wget -c -t 0 -r -np -nd -q --show-progress -T 10 -w 5 -A '.txz' -P $PKGTMP $PKGURI/slackware/$PKG_DEVDL/
    done
    echo "OK.\n\nMemasang paket penuh:"
    sleep 1
    $SETUP/upgradepkg --install-new $PKGTMP/*.txz 2> /dev/null
    echo "\n\nInstalasi paket penuh selesai.\nFinishing ..."
    sleep 1
    INSTALL_STATER
}

INSTALL_STATER () {
    clear
    echo "Memasang script pemicu ..."
    wget -c -q --show-progress -P $HOME/../usr/bin/ $INSTALLPKG_DL/slackwarego
    chmod +x $HOME/../usr/bin/slackwarego
    echo "nameserver 8.8.8.8" > $SLACKWARE/etc/resolv.conf
    echo "OK ..."
    clear
    echo "Membersihkan sisa-sisa instalasi ..."
    sleep 1
    rm -vrf $SLACKWARE/tmp/*
    echo "OK ..."
    sleep 1
    CARA_PAKAI
}

CARA_PAKAI () {
    clear
    echo "SELAMAT! Anda telah berhasil memasang Slackware Linux di perangkat Android.\n\n
    Oleh    : mongkeelutfi
    Info    : mongkee@gmail.com
    Blog    : https://blog.dhocnet.work
    Proyek  : https://github.com/dhocnet/termux-slackwareinstall\n
    Desember 2022, Denpasar, Bali\n
    Untuk menjalankan, gunakan perintah: slackwarego\n"
}

clear
echo "\nSlackware ARM - NetInstall\n-> https://github.com/dhocnet/termux-slackwareinstall/"
sleep 2

SETUP_RESUME(){
    echo "Slackware sudah ada! Apa yang mau dilakukan?
  
    1 - Install ulang
    2 - Hapus Slackware
    3 - Keluar\n"
  
    read -p "Pilihanmu [1,2 atau 3] (default 3)? " mau_apa
    if [ $mau_apa = "1" ]
    then
        echo "Menghapus instalasi lama ..."
        rmdir -vrf $SLACKWARE
        SETUP_MULAI
    elif [ $mau_apa = "2" ]
    then
        echo "Menghapus instalasi Slackware ..."
        rmdir -vrf $SLACKWARE
        echo "Slackware telah dihapus!\n"
    else
        echo "Tidak ada yang dilakukan.\n"
    fi
}

if [ -d $HOME/slackware ]
then
    SETUP_RESUME
else
    SETUP_MULAI
fi
