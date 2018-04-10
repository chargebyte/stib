#!/usr/bin/python
import os
import sys

if len(sys.argv) < 2:
	print("Usage: %s <file1> [<file2>...]" % (sys.argv[0]))
	sys.exit(1)

for fn_old in sorted(sys.argv[1:]):
	parts = fn_old.split(".")
	
	if parts[-1] in [ "gz", "xz" ]:
		pos = -2
	else:
		pos = -1
	parts[pos] = "%02x" % (int(parts[pos]))
	fn_new = ".".join(parts)

	if fn_old == fn_new:
		continue

	print("Renaming: %s --> %s" % (fn_old, fn_new))
	os.rename(fn_old, fn_new)
