#!/bin/sh

# device_sync
# maintain the same Dolphin saves on a Linux computer and an Android phone

# example usage
# $ SAVES_PATH=$HOME/remote-repos/saves ANDROID_IP=192.168.0.24 ANDROID_PORT=38490 LINUX_IP=192.168.0.21 sh device_sync.sh mobile

case $LINUX_IP in "") echo "error: missing LINUX_IP"; ERR=1 ;; esac
case $ANDROID_IP in "") echo "error: missing ANDROID_IP"; ERR=1 ;; esac
case $ANDROID_PORT in "") echo "error: missing ANDROID_PORT"; ERR=1 ;; esac
case $SAVES_PATH in "") echo "error: missing SAVES_PATH"; ERR=1 ;; esac
case $ERR in 1) exit 1 ;; esac

ADOL="/sdcard/Android/data/org.dolphinemu.dolphinemu/files"
LDOL="$LINUX_IP:.local/share/dolphin-emu"

cd "${SAVES_PATH}"

case $1 in
  "")
    printf "What device did you last save to? [{C}onsole/{M}obile] "
    read i_response ;;
  *) i_response="${1}"
esac

# magisk-wifiadb highly recommended to keep this static
adb connect $ANDROID_IP:$ANDROID_PORT

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

adb disconnect
unset i_response

git add *
git commit -m "Sync"
git push

