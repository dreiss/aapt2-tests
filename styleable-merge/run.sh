#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

check_rdot() {
  local SYMBOL="$1"
  local DIR="$2"
  local RDOT="$3"
  grep -q "int $SYMBOL" r-dot/$DIR/$RDOT || {
    echo >&2 "Did not find $SYMBOL in $DIR R.java output."
    exit 1
  }
}

check_bundle() {
  local SYMBOL="$1"
  local BUNDLE="$2"
  grep -q "spec resource 0x[0-9a-f]* com.example:attr/$SYMBOL:" "${BUNDLE}.txt" || {
    echo >&2 "Did not find $SYMBOL in $BUNDLE bundle output."
    exit 1
  }
}

# aapt (1) merges styleable attributes.
$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -S res1 -S res2 -J r-dot/aapt
$AAPT dump --values resources aapt.ap_ > aapt.txt
check_rdot head aapt R.java
check_rdot tail aapt R.java
check_bundle head aapt
check_bundle tail aapt

# aapt2 just picks one declaration.
$AAPT2 compile -o res1.flata --dir res1
$AAPT2 compile -o res2.flata --dir res2
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml  -R res1.flata -R res2.flata --java r-dot/aapt2
$AAPT dump --values resources aapt2.ap_ > aapt2.txt
check_rdot head aapt2 com/example/R.java
check_rdot tail aapt2 com/example/R.java
check_bundle head aapt2
check_bundle tail aapt2
