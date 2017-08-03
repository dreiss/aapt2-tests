#!/bin/bash
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}
set -e

# This tests handling of an invalid gravity attribute.

if [ -z "$ANDROID_PLATFORM" ] ; then
  echo >&2 "Please set ANDROID_PLATFORM to a directory containing android.jar."
  exit 1
fi

# aapt2 generates a warning and omits our layout from the apk,
# but it exits with code 0.
# This results in a successful build and a runtime error.
echo aapt2
$AAPT2 compile -o res.flata --dir res
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml -I $ANDROID_PLATFORM/android.jar -R res.flata
zipinfo aapt2.ap_

echo

# aapt exits with an error code, stopping the build.
echo aapt
if $AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -I $ANDROID_PLATFORM/android.jar -S res
  then echo >&2 "aapt succeeded. oops."
  else echo >&2 "aapt failed. good."
fi
