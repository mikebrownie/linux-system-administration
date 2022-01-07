#!/usr/bin/env bash
# This script sets up iptables rules on A that mirror the rules on the other machines
iptables -F
iptables -X
# First, we add the rules in that are the same for all machines
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# Allow ICMP
iptables -A FORWARD -i lo -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type destination-unreachable -j ACCEPT
# Allow ssh
iptables -A FORWARD -m iprange --src-range 10.21.32.0-10.21.32.255 -p tcp --dport ssh -j ACCEPT
# ------------------------------------------------------------------------------
# MACHINE SPECIFIC RULES: Creating subchains for connections each specific service
iptables -N web_server  # b and f
iptables -N ftp_server # c
iptables -N dns_server # d
iptables -N file_server # e

# We set the default policy to accept for outgoing packets on all machines but c
iptables -A FORWARD -s 100.64.2.2 -j ACCEPT
iptables -A FORWARD -s 100.64.2.4 -j ACCEPT
iptables -A FORWARD -s 100.64.2.5 -j ACCEPT
iptables -A FORWARD -s 10.21.32.2 -j ACCEPT
# Here we add triggers for the different forward chains based on ip address
iptables -A FORWARD -d 100.64.2.2 -j web_server
iptables -A FORWARD -d 100.64.2.3 -j ftp_server
iptables -A FORWARD -s 100.64.2.3 -j ftp_server
iptables -A FORWARD -d 100.64.2.4 -j dns_server
iptables -A FORWARD -d 100.64.2.5 -j web_server
iptables -A FORWARD -d 10.21.32.2 -j file_server

# All except e need more ssh rules for 198.18.0.0/16 and 100.64.0.0/16:
iptables -A web_server -m iprange --src-range 198.18.0.0-198.18.255.254 -p tcp --dport ssh -j ACCEPT
iptables -A web_server -m iprange --src-range 100.64.0.0-100.64.255.254 -p tcp --dport ssh -j ACCEPT
iptables -A dns_server -m iprange --src-range 198.18.0.0-198.18.255.254 -p tcp --dport ssh -j ACCEPT
iptables -A dns_server -m iprange --src-range 100.64.0.0-100.64.255.254 -p tcp --dport ssh -j ACCEPT
iptables -A ftp_server -m iprange --src-range 198.18.0.0-198.18.255.254 -p tcp --dport ssh -j ACCEPT
iptables -A ftp_server -m iprange --src-range 100.64.0.0-100.64.255.254 -p tcp --dport ssh -j ACCEPT

# Machines B and F -------------------------------------------------------------
iptables -A web_server -p tcp --dport 80 -j ACCEPT
iptables -A web_server -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A web_server -j DROP
# Machine C --------------------------------------------------------------------
# FTP
iptables -A ftp_server -p tcp -s 100.64.0.0/16 --dport 21 -j ACCEPT
# Allow DNS
iptables -A OUTPUT -p udp --dport 53 -d 100.64.2.4 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -s 100.64.2.4 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -d 100.64.2.4 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -s 100.64.2.4 -j ACCEPT
# Outbound FTP http://www.devops-blog.net/iptables/iptables-settings-for-outgoing-ftp
iptables -A ftp_server -p tcp --dport  21  -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A ftp_server -p tcp --dport  20  -m state --state ESTABLISHED -j ACCEPT
iptables -A ftp_server -p tcp --sport  1024: --dport  1024: -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT
# HTTP
iptables -A ftp_server -p tcp --dport 80 -j ACCEPT
#HTTPS
iptables -A ftp_server -p tcp --dport 443 -j ACCEPT
# Source: https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
# Outgoing ssh https://www.thegeekstuff.com/2011/03/iptables-inbound-and-outbound-rules/
iptables -A ftp_server -o eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
# Allow icmp
iptables -A ftp_server -p icmp --icmp-type echo-request -j ACCEPT
iptables -A ftp_server -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A ftp_server -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A ftp_server -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A ftp_server -j DROP
# Machine D --------------------------------------------------------------------
# Allow DNS queries from any source
iptables -A dns_server -p udp --dport 53 -j ACCEPT
iptables -A dns_server -j DROP
# Machine E --------------------------------------------------------------------
iptables -A file_server -m iprange --src-range 10.21.32.0-10.21.32.255 -p tcp --dport ssh -j ACCEPT
# Allow CIFS and SMB
iptables -A file_server -p tcp -s 10.21.32.0/24 --dport 135 -j ACCEPT
iptables -A file_server -p udp -s 10.21.32.0/24 --dport 137:139 -j ACCEPT
iptables -A file_server -p tcp -s 10.21.32.0/24 --dport 445 -j ACCEPT
# Default deny INPUT
iptables -A file_server -j DROP

service iptables save
