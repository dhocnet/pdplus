#!/data/data/com.termux/files/usr/bin/bash

#
# Kali Linux chroot start script for Termux
#
# By: Heru N. <desktop.hobbie@gmail.com>
# - https://dhocnet.work
# - https://youtube.com/@dhocnet
# - https://youtube.com/@HotPrendRoom
#

function BOOT_MENU() {
  BOOT=$(dialog --backtitle "Termux Loader for Kali v0.1" \
    --title "Kali Linux Boot Menu" \
    --menu "Choose boot mode." 12 45 25 \
      1 "Kali Linux Text Mode" \
      2 "Kali Linux With Graphical Interface" 2>&1 1>&3)

  if [ "$?" = 0 ]
  then
    export STARTX="$BOOT"
    BOOT_KALI
  else
    echo "BATAL!"
  fi
}

function BOOT_KALI() {
  # setup env
  unset LD_PRELOAD
  export KALI_ROOT="/data/data/com.termux/files/kali"
  TMPDIR="$KALI_ROOT/tmp"
  XDG_RUNTIME_DIR="$TMPDIR"

  # setup mount point
  export MOUNT="busybox mount"
  su -c "$MOUNT -o remount,dev,suid /data"
  su -c "$MOUNT --bind /dev $KALI_ROOT/dev"
  su -c "$MOUNT --bind /dev/pts $KALI_ROOT/dev/pts"
  su -c "$MOUNT --bind /sys $KALI_ROOT/sys"
  su -c "$MOUNT --bind /proc $KALI_ROOT/proc"
  if [ ! -e "$KALI_ROOT/mnt/Disk1" ]
  then
    su -c "mkdir $KALI_ROOT/mnt/Disk1"
    su -c "chmod a+rw $KALI_ROOT/mnt/Disk1"
  elif [ ! -e "$KALI_ROOT/mnt/Disk2" ]
  then
    su -c "mkdir $KALI_ROOT/mnt/Disk2"
    su -c "chmod a+rw $KALI_ROOT/mnt/Disk2"
  fi
  su -c "$MOUNT --bind /storage/emulated/0 $KALI_ROOT/mnt/Disk1"
  # MOUNT SDCARD IF EXISTS MANUALY
  # su -c "$MOUNT --bind /storage/<SDCARD DIR> $KALI_ROOT/mnt/Disk2"

  # ENTERING KALI
  if [ "$STARTX" = 2 ]
  then
    # START X11 SERVER
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
    termux-x11 :0 -ac &
    su -c "touch $KALI_ROOT/tmp/startx.y"
  fi
  su -c "busybox chroot $KALI_ROOT /bin/su - kali"
  pkill -9 app_process
  # LEAVING KALI CHROOT
  CLEANING_CHROOT
}

function CLEANING_CHROOT() {
  su -c "umount -f $KALI_ROOT/dev/pts"
  su -c "umount -f $KALI_ROOT/dev"
  su -c "umount $KALI_ROOT/proc"
  su -c "umount $KALI_ROOT/sys"
  if [ "$STARTX" = 2 ]
  then
    su -c "rm $KALI_ROOT/tmp/startx.y"
  fi
  echo "DONE!"
}

#
### tidak peelu root untuk memulai
#
if [ "$(whoami)" = "root" ]
then
  echo -e "\n\033[1m\033[5m\033[91m\033[103mROOT DILARANG MASUK!!!\033[0m \n"
  exit 1
fi

exec 3>&1

BOOT_MENU
