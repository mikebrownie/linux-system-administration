#!/usr/bin/env bash
# MACHINE B and F
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

# HTTP
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# HTTPS
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT


# Default deny INPUT
iptables -A INPUT -j DROP
# Default deny FORWARD
iptables -A FORWARD -j DROP
# Ensure forwarding is disabled through kernel
sysctl -w net.ipv4.ip_forward=0

service iptables save
