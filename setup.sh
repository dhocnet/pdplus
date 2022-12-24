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
PKGURI=https://ftp.halifax.rwth-aachen.de/slackwarearm/slackwareaarch64-current
INSTALLPKG_DL=https://raw.githubusercontent.com/dhocnet/termux-slackwareinstall/main

# MINIROOT PKG BY ALIEN BOB 
CATA="aaa_base
aaa_elflibs
aaa_terminfo
acl
attr
bash
tar
bin
btrfs-progs
bzip2
coreutils
dbus
dcron
devs
dialog
e2fsprogs
ed
etc
file
findutils
hostname
hwdata
lbzip2
less
gawk
gettext
getty-ps
glibc-solibs
glibc-zoneinfo
gptfdisk
grep
gzip
jfsutils
inotify-tools
kmod
lrzip
lzip
lzlib
pkgtools
procps-ng
reiserfsprogs
shadow
sed
sysklogd
usbutils
util-linux
which
xfsprogs
xz"

CATAP="groff
aman-db
man-pages
nano
slackpkg"

CATD="perl
python
python-pip
python-setuptools"

CATN="openssl
ca-certificates
gnupg
lftp
libmnl
network-scripts
nfs-utils
ntp
iputils
net-tools
iproute2
openssh
rpcbind
libtirpc
rsync
telnet
traceroute
wget
wpa_supplicant
wireless-tools"

CATL="lzo
libnl3
libidn
libunistring
mpfr
ncurses
pcre"

SETUP_MULAI () {
    clear
    # konfirmasi instalasi paket yang dibutuhkan oleh slackware
    # pkgtools
    echo "Anda membutuhkan beberapa program lain untuk
menyelesaikan instalasi Slackware. Yaitu:

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
    pkg upgrade && pkg install grep coreutils lzip proot tar wget util-linux dialog
    sleep 1
    SETUP_SELECT
}

SETUP_SELECT () {
    clear
    echo "PILIH JENIS INSTALASI
    
    1) Minimalis - Download 76MB+/inst: 350MB+
    2) Penuh tanpa X - Download: 1.2GB+/inst: 7.7GB+
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
    echo "\nMengunduh program installer:"
    wget -c -t 0 -P $SETUP/ -q --show-progress $INSTALLPKG_DL/installpkg
    chmod +x $SETUP/installpkg
    echo "OK.\n"
    if [ $pilih_tipe = "2" ]
    then
        INSTALL_DEVEL
    else
        INSTALL_DEFAULT
    fi
}

INSTALL_DEFAULT () {
    clear
    touch $SLACKWARE/tmp/setup.mini
    echo "Mengunduh paket minimal:"
    sleep 1
    PKG_MIN="a ap d n l"
    for PKG_CAT in $PKG_MIN ; do
        if [ $PKG_CAT = "a" ]
        then
	    PKGDL=$CATA
        elif [ $PKG_CAT = "ap" ]
        then
            PKGDL=$CATAP
        elif [ $PKG_CAT = "d" ]
        then
            PKGDL=$CATD
        elif [ $PKG_CAT = "n" ]
        then
            PKGDL=$CATN
        else
            PKGDL=$CATL
        fi
        for PKG_TODL in $PKGDL ; do
            wget -c -t 0 -T 10 -w 5 -P $PKGTMP/ -q --show-progress -r -np -nd -A "$PKG_TODL-*.txz" $PKGURI/slackware/$PKG_CAT/
        done
    done
    echo "OK.\n"
    echo "Memasang Slackware minimal ..."
    sleep 2
    INSTALL_PAKET
}

INSTALL_DEVEL () {
    clear
    touch $SLACKWARE/tmp/setup.full
    PKG_DEVDIR="a ap d e l n t"
    echo "Mengunduh paket penuh:"
    sleep 1
    for PKG_DEVDL in $PKG_DEVDIR ; do
        wget -c -t 0 -np -nd -q --show-progress -T 10 -w 5 -r -l 1 -A "txz" -P $PKGTMP/ $PKGURI/slackware/$PKG_DEVDL/
    done
    echo "OK.\n\nMemasang Slackware penuh ..."
    sleep 1
    INSTALL_PAKET
}

INSTALL_PAKET () {
    $SETUP/installpkg --terse --root $SLACKWARE/ $PKGTMP/*.txz 2> /dev/null
    echo "\n\nInstalasi Slackware selesai ..."
    sleep 1
    INSTALL_STATER
}

INSTALL_STATER () {
    clear
    echo "Memasang script pemicu ..."
    wget -c -q --show-progress -P $HOME/../usr/bin/ $INSTALLPKG_DL/slackwarego
    chmod +x $HOME/../usr/bin/slackwarego
    echo "nameserver 8.8.8.8" > $SLACKWARE/etc/resolv.conf
    if [ -f $SLACKWARE/tmp/setup.full ]
    then
        rm $SLACKWARE/tmp/setup.full
    else
        rm $SLACKWARE/tmp/setup.mini
    fi
    echo "Bersihkan paket yang di download?"
    read -p "Ya/ Tidak (default N) [y/N]? " hapus_tmp
    if [ $hapus_tmp = "y" ]
    then
        echo "Membersihkan paket sementara ..."
        sleep 1
        rm -vrf $SLACKWARE/tmp/*
        echo "OK ..."
        sleep 1
    fi
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

SETUP_RESUME () {
    if [ -f $SLACKWARE/tmp/setup.full ] || [ -f $SLACKWARE/tmp/setup.mini ]
    then
        echo "\nLanjutkan instalasi yang terhenti?\n"
        read -p "Ya/ Tidak (default N) [y/N]? " lanjutkah
        if [ $lanjutkah = "y" ]
        then
            if [ -f $SLACKWARE/tmp/setup.full ]
            then
                INSTALL_DEVEL
            else
                INSTALL_DEFAULT
            fi
        else
            INSTALL_ULANG
        fi
    else
        INSTALL_ULANG
    fi
}

INSTALL_ULANG () {
    echo "\nSlackware sudah ada! Apa yang mau dilakukan?
  
    1 - Install ulang
    2 - Hapus Slackware
    3 - Keluar\n"
  
    read -p "Pilihanmu [1,2 atau 3] (default 3)? " mau_apa
    if [ $mau_apa = "1" ]
    then
        echo "\nMenghapus instalasi lama ..."
        rm -vrf $SLACKWARE
        rm -v $HOME/../usr/bin/slackwarego
        sleep 2
        SETUP_MULAI
    elif [ $mau_apa = "2" ]
    then
        echo "\nMenghapus instalasi Slackware ..."
        rm -vrf $SLACKWARE
        rm -v $HOME/../usr/bin/slackwarego
        echo "\nSlackware telah dihapus!\n"
        sleep 2
    else
        echo "\nTidak ada yang dilakukan.\n"
    fi
}

clear
echo "\nSlackware-current AARCH64 - NetInstall\n-> https://github.com/dhocnet/termux-slackwareinstall/"
sleep 2

if [ -d $HOME/slackware ]
then
    SETUP_RESUME
else
    SETUP_MULAI
fi
