#!/bin/bash
: ${AAPT:=aapt}
: ${AAPT2:=aapt2}

# Both aapt and aapt2 (correctly) fail to compile an invalid 9-patch.
# But aapt reports the file and exact pixel where the problem occurred,
# while aapt2 gives an inscrutable error message.

$AAPT package --auto-add-overlay -f -F aapt.ap_ -M AndroidManifest.xml -S res 2> aapt-output.txt || true
$AAPT2 compile -o res.flata --dir res 2> aapt2-output.txt || true

tail -n99 aapt-output.txt aapt2-output.txt
echo

for TOOL in aapt aapt2 ; do
  grep -q "preposterous" $TOOL-output.txt || {
    echo >&2 "Did not find file name in $TOOL output."
    exit 1
  }
done
