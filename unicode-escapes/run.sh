#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

# I didn't bother writing an automated verifier for this one because
# the issue is fixed in 26.0.0-preview

# aapt and aapt2 26.0.0-preview handle this identically.
echo aapt
$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -S res
$AAPT dump strings aapt.ap_ | grep 'String #.*Snowman'
$AAPT dump xmltree aapt.ap_ res/xml/box.xml | grep text

echo aapt2
$AAPT2 compile -o res.flata --dir res
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml  -R res.flata
# aapt2 from AOSP truncates the string resource.
$AAPT dump strings aapt2.ap_ | grep 'String #.*Snowman'
# and doesn't decode the escape sequence in the xml attribute.
$AAPT dump xmltree aapt2.ap_ res/xml/box.xml | grep text
