#!/bin/bash

echo "Starting rtl_tcp in background"
rtl_tcp &   # run in background 

echo "Waiting 15 seconds to start rtlamr"
sleep 15 # wait for rtl_tcp tp start

echo "Starting rtlamr"
rtlamr



