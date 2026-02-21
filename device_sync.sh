#!/bin/sh

# sync game saves, only updating files that are newer
# push changes to Git

case $1 in
  "")
    printf "What device did you last save to? [{C}onsole/{M}obile] "
    read i_response ;;
  *) i_response="${1}"
esac

case $i_response in
C*)
  rsync -aurptv 192.168.0.183:.local/share/dolphin-emu/GC/* $PWD/GC/
  rsync -aurptv 192.168.0.183:.local/share/dolphin-emu/Wii/*  $PWD/Wii/
;;
M*)
  adb pull /sdcard/Android/data/org.dolphinemu.dolphinemu/files/GC $PWD
  adb pull /sdcard/Android/data/org.dolphinemu.dolphinemu/files/Wii $PWD
;;
esac

unset i_response

cd $HOME/remote-repos/saves
git add *
git commit -m "Sync"
git push

