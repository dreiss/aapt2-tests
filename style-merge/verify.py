#!/usr/bin/env python
import sys
import re

def parse_dump(filename):
    """Returns the set of dimensions under MyTheme"""
    with open(filename) as handle:
        dimension_indent = -1
        dimensions = set()
        for line in handle:
            indent = len(re.sub('\S.*', "", line.rstrip()))
            if re.search(r'resource 0x[0-9a-f]+ com.example:style/MyTheme: <bag>', line):
                dimension_indent = indent
                continue
            if indent <= dimension_indent:
                break
            m = re.search(r'.dimension. ([\d.]+)dp', line)
            if m:
                dimensions.add(m.group(1))
        return dimensions


def main(argv):
    aapt_dims = parse_dump(argv[1])
    aapt2_dims = parse_dump(argv[2])

    if aapt_dims != aapt2_dims:
        print("Mismatch!  aapt.txt = %r, aapt2.txt = %r." % (aapt_dims, aapt2_dims))
        return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
