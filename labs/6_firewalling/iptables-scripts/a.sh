#!/usr/bin/env bash
# MACHINE A
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

# Allow ssh
iptables -A INPUT -m iprange --src-range 198.18.0.0-198.18.255.254 -p tcp --dport ssh -j ACCEPT
iptables -A INPUT -m iprange --src-range 10.21.32.0-10.21.32.255 -p tcp --dport ssh -j ACCEPT
iptables -A INPUT -m iprange --src-range 100.64.0.0-100.64.255.254 -p tcp --dport ssh -j ACCEPT
## END This part is the same for all machines ----------------------------------

## START machine a specific rules: ---------------------------------------------
# Allow DHCP
iptables -A INPUT -i ens192 -p udp --dport 67:68 --sport 67:68 -j ACCEPT
iptables -A INPUT -i ens224 -p udp --dport 67:68 --sport 67:68 -j ACCEPT


# Block facebook.com
iptables -A FORWARD -d 157.240.28.35 -j DROP
iptables -A FORWARD -s 157.240.28.35 -j DROP
# Block icanhas.cheezburger.com and cheezburger.com
iptables -A FORWARD -d 216.176.186.210 -j DROP
iptables -A FORWARD -s 216.176.186.210 -j DROP

# Default deny INPUT
iptables -A INPUT -j DROP
# Ensure forwarding is enabled through kernel
sysctl -w net.ipv4.ip_forward=1

service iptables save
