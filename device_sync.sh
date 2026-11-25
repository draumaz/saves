#!/bin/sh -e

# device_sync
# Relay Dolphin saves between this repo and an Android phone over adb.
# Normally run over ssh by dolsyn (github.com/draumaz/lindots, bin/dolsyn).
#
# example usage
# $ ANDROID_IP=192.168.0.24 ANDROID_PORT=38490 sh device_sync.sh to-phone
#     to-phone    copy the repo's GC and Wii saves onto the phone
#     from-phone  copy the phone's saves into the repo, commit and push

case $ANDROID_IP in "") echo "error: missing ANDROID_IP"; ERR=1 ;; esac
case $ANDROID_PORT in "") echo "error: missing ANDROID_PORT"; ERR=1 ;; esac
case $ERR in 1) exit 1 ;; esac

ADOL="/sdcard/Android/data/org.dolphinemu.dolphinemu/files"
PHONE="${ANDROID_IP}:${ANDROID_PORT}"

cd "`dirname "$0"`"

# magisk-wifiadb highly recommended to keep this static
adb connect "${PHONE}"
trap 'adb disconnect "${PHONE}" >/dev/null' EXIT

case $1 in
  to-phone)
    for i in GC Wii; do adb -s "${PHONE}" push "$i" "${ADOL}/"; done ;;
  from-phone)
    for i in GC Wii; do adb -s "${PHONE}" pull "${ADOL}/$i" .; done
    git add -A
    git diff --cached --quiet || git commit -q -m "Sync from phone"
    git push -q ;;
  *) echo "usage: device_sync.sh to-phone|from-phone"; exit 1 ;;
esac
