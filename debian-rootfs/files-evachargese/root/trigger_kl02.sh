#!/bin/sh

while [ true ]; do 
  python uss.py -p/dev/ttyAPP2 -i >/dev/null 2>&1
  sleep 10
done

