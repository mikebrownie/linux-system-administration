#!/usr/bin/env bash
if [ "$#" != "1" ]; then echo "Required arg: threshold percent of drive usage for email notification (0-100)"; exit -1; fi

THRESHOLD=$1

ROOT_USAGE=$(df | grep "/$" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')

BOOT_USAGE=$(df | grep "/boot" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')

i=0

while [ $i -lt 100 ]
do
  if [ $BOOT_USAGE -gt $THRESHOLD ]
  then
    echo "/boot usage $THRESHOLD exceeded: at $BOOT_USAGE" | mailx -s "ALERT" root@localhost
  fi
  if [ $ROOT_USAGE -gt $THRESHOLD ]
  then
    echo "root / usage $THRESHOLD exceeded: at $ROOT_USAGE" | mailx -s "ALERT" root@localhost
  fi
  sleep 15
  i=`expr $i + 1`;
done;
