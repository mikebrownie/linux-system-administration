#!/usr/bin/env bash
ROOT_USAGE=$(df | grep "/$" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')

BOOT_USAGE=$(df | grep "/boot" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')

i=0

while [ $i -lt 100 ]
do
  if [ $BOOT_USAGE -gt 80 ]
  then
    echo "/boot usage at $BOOT_USAGE" | mailx -s "ALERT" root@localhost
  fi
  if [ $ROOT_USAGE -gt 80 ]
  then
    echo "root / usage at $ROOT_USAGE" | mailx -s "ALERT" root@localhost
  fi
  sleep 15
  i=`expr $i + 1`;
done;
