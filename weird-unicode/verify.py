#!/usr/bin/env python
import sys

with open(sys.argv[1]) as handle:
    content = handle.read()
try:
    content.decode("utf-8")
except UnicodeDecodeError as e:
    print >>sys.stderr, "Invalid UTF-8 in %s: %s" % (sys.argv[1], e)
