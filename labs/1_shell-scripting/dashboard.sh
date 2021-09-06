#!/usr/bin/env bash

display_mem_res()
{
  echo 'CPU AND MEMORY RESOURCES --------------------------------'
  avgs=$(uptime | awk '{print $7,$8,$9,$10}')
  echo "CPU Load Average: $avgs"
  ram=$(free -m | awk 'FNR == 2 {print $3}')
  echo "Free RAM: $ram MB"
}

display_mem_res
