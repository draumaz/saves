#!/bin/sh

# sync saves from thalassa + Pixel
# only modify synced files that are newer
# sync changes to Git

printf "What device did you last save to? [{C}onsole/{M}obile] "
read i_response

mkdir /tmp/dolphin-sync /tmp/dolphin-sync/console /tmp/dolphin-sync/mobile

case $i_response in
C*)
  rsync -aurptv 192.168.0.183:.local/share/dolphin-emu/GC/* $HOME/remote-repos/saves/GC/
  rsync -aurptv 192.168.0.183:.local/share/dolphin-emu/Wii/*  $HOME/remote-repos/saves/Wii/
;;
M*)
  adb pull /sdcard/Android/data/org.dolphinemu.dolphinemu/files/GC $HOME/remote-repos/saves/
  adb pull /sdcard/Android/data/org.dolphinemu.dolphinemu/files/Wii $HOME/remote-repos/saves/
;;
esac

unset i_response

cd remote-repos/saves
git add *
git commit -m "Sync"
git push

