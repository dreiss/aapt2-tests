#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

if [ -z "$ANDROID_PLATFORM" ] ; then
  echo >&2 "Please set ANDROID_PLATFORM to a directory containing android.jar."
  exit 1
fi

echo aapt
$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -I $ANDROID_PLATFORM/android.jar

echo aapt2
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml -I $ANDROID_PLATFORM/android.jar
