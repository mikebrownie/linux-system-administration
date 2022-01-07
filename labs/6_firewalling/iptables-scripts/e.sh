#!/usr/bin/env bash
# MACHINE E
iptables -F
## Start the same for all machines ---------------------------------------------
# Allow related and established connections with conntrack
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# Allow ICMP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
## END This part is the same for all machines ----------------------------------

## START machine a specific rules: ---------------------------------------------
# Allow ssh
iptables -A INPUT -m iprange --src-range 10.21.32.0-10.21.32.255 -p tcp --dport ssh -j ACCEPT
# Allow CIFS and SMB
iptables -A INPUT -p tcp -s 10.21.32.0/24 --dport 135 -j ACCEPT
iptables -A INPUT -p udp -s 10.21.32.0/24 --dport 137:139 -j ACCEPT
iptables -A INPUT -p tcp -s 10.21.32.0/24 --dport 445 -j ACCEPT

# Default deny INPUT
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP
# Ensure forwarding is disabled through kernel
sysctl -w net.ipv4.ip_forward=0

service iptables save
