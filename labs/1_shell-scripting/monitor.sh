!#/bin/bash

ROOT_USAGE=$(df | grep "/$" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')

BOOT_USAGE=$(df | grep "/boot" | awk '{print $5,$6}' | awk '{print $1}' | sed 's/%//')



