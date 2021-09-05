#!/usr/bin/env bash
ROOT_USAGE=$(df | grep "/$" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')

BOOT_USAGE=$(df | grep "/boot" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')

i=0

while [ $i -lt 1000 ]
do
  if [ $BOOT_USAGE -gt 80 ]
  then
    echo "Uh oh"
  fi
  if [ $ROOT_USAGE -gt 80 ]
  then
    echo "Uh oh"
  fi
  sleep 15
  i=`expr $i + 1`;
done;

