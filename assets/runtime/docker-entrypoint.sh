#!/bin/sh

set -x

while [ 0 ]
do
  sleep 365d &
  wait
  pkill sleep
done
