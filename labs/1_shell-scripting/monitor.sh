#!#/bin/bash

ROOT_USAGE=$(df | grep "/$" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//');

BOOT_USAGE=$(df | grep "/boot" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//');

i=0;

while [ $i -lt 10 ]
do
  if [ $BOOT_USAGE -lt 80 ]
  then
    echo "Uh oh";
  if [ ROOT_USAGE -lt 80 ]
  then
    echo "Uh oh";
  fi
  i=`expr $i + 1`;
