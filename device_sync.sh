#!/bin/sh

# sync game saves, only updating files that are newer
# push changes to Git

ADOL="/sdcard/Android/data/org.dolphinemu.dolphinemu/files"
LDOL="192.168.0.183:.local/share/dolphin-emu"

cd $HOME/remote-repos/saves

case $1 in
  "")
    printf "What device did you last save to? [{C}onsole/{M}obile] "
    read i_response ;;
  *) i_response="${1}"
esac

case $i_response in
  C*|c*)
    for i in GC Wii; do
      scp -pr $LDOL/$i $PWD
      adb push $PWD/$i $ADOL/
    done ;;
  M*|m*)
    for i in GC Wii; do
      adb pull $ADOL/$i $PWD
      scp -pr $PWD/$i $LDOL
    done ;;
esac

unset i_response

git add *
git commit -m "Sync"
git push

