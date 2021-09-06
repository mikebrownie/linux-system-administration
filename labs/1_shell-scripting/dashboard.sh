#!/usr/bin/env bash

display_mem_res()
{
  echo 'CPU AND MEMORY RESOURCES --------------------------------'
  avgs=$(uptime | awk '{print $7,$8,$9,$10}')
  echo "CPU Load Average: $avgs"
  ram=$(free -m | awk 'FNR == 2 {print $3}')
  echo "Free RAM: $ram MB"
}


display_net_info()
{
  echo 'NETWORK CONNECTIONS -------------------------------------'
  rec=$(cat /proc/net/dev | awk 'FNR == 4 {print $2}')
  sent=$(cat /proc/net/dev | awk 'FNR == 4 {print $10}')
  echo "lo Bytes Received: $rec Transmitted: $sent"

  rec=$(cat /proc/net/dev | awk 'FNR == 3 {print $2}')
  sent=$(cat /proc/net/dev | awk 'FNR == 3 {print $10}')
  echo "enp0s3 Bytes Received: $rec Transmitted: $sent"

  is_connected=$(ping -c 1 8.8.8.8 | grep '1 received' | wc -l)

  if [ $is_connected = '1' ]; then echo "Internet connection: True"; else echo  "Internet connection: False"; fi

}

display_mem_res
display_net_info
