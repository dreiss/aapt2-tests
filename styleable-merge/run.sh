#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

# aapt (1) merges styleable attributes.
$AAPT package --auto-add-overlay -M AndroidManifest.xml -S res1 -S res2 -J r-dot/aapt --output-text-symbols r-dot/aapt
grep -q 'int head' r-dot/aapt/R.java || {
  echo >&2 'Did not find head in aapt output.'
  exit 1
}
grep -q 'int tail' r-dot/aapt/R.java || {
  echo >&2 'Did not find tail in aapt output.'
  exit 1
}

# aapt2 just picks one declaration.
$AAPT2 compile -o res1.flata --dir res1
$AAPT2 compile -o res2.flata --dir res1
$AAPT2 link --auto-add-overlay -o r-dot/aapt2/res.ap_ --manifest AndroidManifest.xml  -R res1.flata -R res2.flata --java r-dot/aapt2
grep -q 'int head' r-dot/aapt2/com/example/R.java || {
  echo >&2 'Did not find head in aapt2 output.'
  exit 1
}
grep -q 'int tail' r-dot/aapt2/com/example/R.java || {
  echo >&2 'Did not find tail in aapt2 output.'
  exit 1
}
