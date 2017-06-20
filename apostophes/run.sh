#!/bin/bash
set -e
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

# Using un-escaped single quotes in attributes in xml resources
# or as un-translated text values in xml layouts
# appears to be totally valid.
# aapt has no problem with it, but aapt2 truncates the strings.

check_xml() {
  local TOOL="$1"
  local PATTERN="$2"

  $AAPT dump xmltree $TOOL.ap_ res/xml/box.xml | grep -q "$PATTERN" || {
    echo >&2 "Did not find $PATTERN in $TOOL apk."
    exit 1
  }
}

$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -S res
check_xml aapt 'text.*m corr'
check_xml aapt 'text.*t corr'

$AAPT2 compile -o res.flata --dir res
$AAPT2 link --auto-add-overlay -o aapt2.ap_ --manifest AndroidManifest.xml -R res.flata
check_xml aapt2 'text.*m corr'
check_xml aapt2 'text.*t corr'
