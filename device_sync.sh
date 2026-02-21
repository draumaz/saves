#!/bin/sh

# sync game saves, only updating files that are newer
# push changes to Git

ADOL="/sdcard/Android/data/org.dolphinemu.dolphinemu/files"
LDOL="192.168.0.183:${HOME}/.local/share/dolphin-emu"

case $1 in
  "")
    printf "What device did you last save to? [{C}onsole/{M}obile] "
    read i_response ;;
  *) i_response="${1}"
esac

case $i_response in
  C*)
    for i in GC Wii; do
      scp -pr $LDOL/$i $PWD
      adb push $PWD/$i $ADOL/
    done ;;
  M*)
    for i in GC Wii; do
      adb pull $LDOL/$i $PWD/
      scp -pr $PWD/$i $LDOL
    done ;;
esac

unset i_response

cd $HOME/remote-repos/saves
git add *
git commit -m "Sync"
git push

