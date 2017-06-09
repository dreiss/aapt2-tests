#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

# aapt (1) merges style items
$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -S res1 -S res2
$AAPT dump --values resources aapt.ap_ > aapt.txt

# aapt2 just picks one declaration.
$AAPT2 compile -o res1.flata --dir res1
$AAPT2 compile -o res2.flata --dir res1
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml  -R res1.flata -R res2.flata
$AAPT dump --values resources aapt2.ap_ > aapt2.txt

./verify.py aapt.txt aapt2.txt
