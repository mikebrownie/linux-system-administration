#!/usr/bin/env bash
# MACHINE C
iptables -F
# Need this b/c default outbound policy is DROP
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
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
iptables -A INPUT -m iprange --src-range 10.21.32.0-10.21.255.254 -p tcp --dport ssh -j ACCEPT
iptables -A INPUT -m iprange --src-range 100.64.0.0-100.64.255.254 -p tcp --dport ssh -j ACCEPT
## END This part is the same for all machines ----------------------------------

## START machine c specific rules: ---------------------------------------------
# FTP
iptables -A INPUT -p tcp -s 100.64.0.0/16 --dport 21 -j ACCEPT
# Allow DNS
iptables -A OUTPUT -p udp --dport 53 -d 100.64.2.4 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -s 100.64.2.4 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -d 100.64.2.4 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -s 100.64.2.4 -j ACCEPT
# Outbound FTP http://www.devops-blog.net/iptables/iptables-settings-for-outgoing-ftp
iptables -A OUTPUT -p tcp --dport  21  -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport  20  -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport  1024: --dport  1024: -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT

# HTTP
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
#HTTPS
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
# Source: https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands

# Outgoing ssh https://www.thegeekstuff.com/2011/03/iptables-inbound-and-outbound-rules/
iptables -A OUTPUT -o ens192 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

# Allow icmp
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type destination-unreachable -j ACCEPT

# Default deny INPUT and OUTPUT
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
# Default deny FORWARD
iptables -A FORWARD -j DROP
# Ensure forwarding is disabled through kernel
sysctl -w net.ipv4.ip_forward=0

service iptables save
