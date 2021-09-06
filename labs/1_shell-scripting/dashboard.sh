#!/usr/bin/env bash
# This script displays commonly used info on a cool dashboard 

display_mem_res()
{
  echo 'CPU AND MEMORY RESOURCES --------------------------------'
  avgs=$(uptime | awk '{print $8,$9,$10}')
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

display_account_info()
{
  echo 'ACCOUNT INFORMATION -------------------------------------'
  num_users=$(cat /etc/passwd | wc -l)
  num_active=$(who | wc -l)
  shells=$(cat /etc/passwd | cut -d ':' -f 7 | sort | uniq -c)
  echo "Total users: $num_users"
  echo "Active users: $num_active"
  echo "Count + Shells:"
  echo $shells
}

display_filesys_info()
{
  echo 'FILESYSTEM INFORMATION ----------------------------------'
  iused=$(df --inodes / | awk 'FNR == 2 {print $3}')
  echo "Total Number of Files (inodes used): $iused"
  dirs=$(find / -type d | wc -l)
  echo "Total Number of Directories: $dirs"
}

display_mem_res
display_net_info
display_account_info
display_filesys_info
