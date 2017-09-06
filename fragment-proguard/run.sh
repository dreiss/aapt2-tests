#!/bin/bash
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}
set -e

if [ -z "$ANDROID_PLATFORM" ] ; then
  echo >&2 "Please set ANDROID_PLATFORM to a directory containing android.jar."
  exit 1
fi

check_proguard() {
  local TOOL="$1"
  local CLASSNAME="$2"
  grep -q "$CLASSNAME" "${TOOL}.pro" || {
    echo >&2 "Did not find $CLASSNAME in $TOOL proguard output."
    exit 1
  }
}

# aapt (1) recognizes both the "class" and "android:name" attributes
# of fragment tags.
$AAPT package --auto-add-overlay -f -F aapt.ap_ -G aapt.pro -M AndroidManifest.xml -I $ANDROID_PLATFORM/android.jar -S res
check_proguard aapt AndroidClassFragment
check_proguard aapt AndroidNameFragment

# aapt2 only recognizes "class".
$AAPT2 compile -o res.flata --dir res
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --proguard aapt2.pro --manifest AndroidManifest.xml -I $ANDROID_PLATFORM/android.jar -R res.flata
check_proguard aapt2 AndroidClassFragment
check_proguard aapt2 AndroidNameFragment
