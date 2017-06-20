#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

# aapt silently drops the backslash-escaped fancy quotation mark, which is bad.
$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -S res
$AAPT dump strings aapt.ap_ > aapt.txt
./verify.py aapt.txt

# aapt2 outputs invalid UTF-8, which is even worse.
# Failing the compile would probably be the best option.
$AAPT2 compile -o res.flata --dir res
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml -R res.flata
$AAPT dump strings aapt2.ap_ > aapt2.txt
./verify.py aapt2.txt
