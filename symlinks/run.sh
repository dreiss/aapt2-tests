#!/bin/bash
set -e
: ${AAPT2:=aapt2}

# Try to compile a resource dir with a symlink.
# aapt2 from 26.0.0-preview doesn't tolerate it.
# aapt2 from AOSP is fine.

$AAPT2 compile -o out.flata --dir res
