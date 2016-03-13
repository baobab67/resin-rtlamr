#!/bin/bash

echo "Starting rtl_tcp in background"
 rtl_tcp > /dev/null &   # run in background and suppress ll
#rtl_tcp 2> >(grep -v 'll*' 1>&2) & # suppress stderr that starts "ll"

echo "Waiting 15 seconds for rtl_tcp to start"
sleep 15 # wait for rtl_tcp tp start

echo "Starting rtlamr"
rtlamr 



