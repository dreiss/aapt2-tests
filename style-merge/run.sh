#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

check() {
  local SYMBOL="$1"
  local DIR="$2"
  local RDOT="$3"
  grep -q "int $SYMBOL" r-dot/$DIR/$RDOT || {
    echo >&2 "Did not find $SYMBOL in $DIR output."
    exit 1
  }
}

# aapt (1) merges style items
$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -S res1 -S res2 -J r-dot/aapt
$AAPT dump --values resources aapt.ap_ > aapt.txt
check mywidth aapt R.java
check myheight aapt R.java
check s1_mywidth aapt R.java
check s2_myheight aapt R.java

# aapt2 just picks one declaration.
$AAPT2 compile -o res1.flata --dir res1
$AAPT2 compile -o res2.flata --dir res2
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml  -R res1.flata -R res2.flata --java r-dot/aapt2
$AAPT dump --values resources aapt2.ap_ > aapt2.txt
check mywidth aapt2 com/example/R.java
check myheight aapt2 com/example/R.java
check s1_mywidth aapt2 com/example/R.java
check s2_myheight aapt2 com/example/R.java

# Verify the resource bundle.
# Note that this won't run unless all of the R.java checks above pass.
# Comment them out to force this to run.
./verify.py aapt.txt aapt2.txt
