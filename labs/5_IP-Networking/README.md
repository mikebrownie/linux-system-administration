# Lab 5 - IP Networking

## Initial Set Up

### What's needed to setup DHCP?
First, you'll need to install the DHCP daemon that serves IP addresses and other configuration information:
```
root@machinea# yum install dhcp
```
The hosts on our production network are servers, so we want them to have fixed IP address.  Create a static MAC to IP mapping on Machine A:
```
root@machinea# vi /etc/dhcp/dhcpd.conf
root@machinea# systemctl restart dhcpd
```
You’ll also want to configure the dhcp server to set the appropriate hostname on all the machines.  Finally, you'll need to figure out how to get machines B through F to pick up the configuration from machine A's dhcp daemon by modifying the appropriate ifcfg file in /etc/sysconfig/network-scripts.

 

### What's needed to setup DNS?
We'll need the daemon that serves DNS, known alternatively as BIND or named:
```
root@machined# yum install bind bind-utils
```
We'll then need to populate the named configuration file to serve the addresses in the configuration table below:
```
root@machined# vi /etc/named.conf
root@machined# systemctl restart named
 ```
 
### What's needed to set up a new web server?
Once machine F is properly configured as a host on the network, install a daemon to service http requests.  This is most often the daemon known as Apache or httpd::
```
root@machinef# yum install httpd
root@machinef# systemctl enable httpd
root@machinef# systemctl start httpd
```
Once Apache is running, it automatically serves files in directory /var/www/html/  under the URL of http://100.64.N.5.  Please note that the firewall (iptables) on machine F may be configured to block requests to port 80 by default.  You can temporarily ‘drop’ this firewall as follows:
```
root@Machinef# systemctl stop iptables
root@Machinef# systemctl disable iptables
```
You’ll also need to copy the web content from the old web server to the new one.  The rsync tool, which can reliably transfer files over ssh, can do this.  First install rsync on both machines:
```
root@machineb# yum install rsync
root@machinef# yum install rsync
```
Then push contents of /var/www/ on machineb to /var/www/ on machinef:
```
root@machineb# rsync -av /var/www root@100.64.N.5:/var/.
```
Realize that this will only push the contents once. What we really need is to have the machines stay in sync by pushing the content on a periodic basis.

 

## Dunder Mifflin Network Topology & Configuration

D-M currently has the following CentOS Linux machines:

router supports dhcp, ip_forwarding, and network/port address translation (nat/pat).

carriage (the http server) hosts the D-M website(s).

platen (the ftp server) updates prices and accepts batch orders.

chase (the dns server) maps between domain names and IP addresses.

roller (the file server) stores company files centrally.

saddle (the backup http server) makes Michael Scott happy.

## Rules
```
Name	IP Address or Name	Record Type	TTL
router.dundermifflin.com.	100.64.0.N	A	1 hour
carriage.dundermifflin.com.	100.64.N.2	A	1 hour
platen.dundermifflin.com.	100.64.N.3	A	1 hour
chase.dundermifflin.com.	100.64.N.4	A	1 hour
roller.dundermifflin.com.	10.21.32.2	A	1 hour
saddle.dundermifflin.com.	100.64.N.5	A	1 hour
machinea.dundermifflin.com.	router.dundermifflin.com.	CNAME	7 days
machineb.dundermifflin.com.	carriage.dundermifflin.com.	CNAME	7 days
machinec.dundermifflin.com.	platen.dundermifflin.com.	CNAME	7 days
machined.dundermifflin.com.	chase.dundermifflin.com.	CNAME	7 days
machinee.dundermifflin.com.	roller.dundermifflin.com.	CNAME	7 days
machinef.dundermifflin.com.	saddle.dundermifflin.com.	CNAME	7 days
dundermifflin.com.	carriage.dundermifflin.com	CNAME	5 minutes
www.dundermifflin.com.	carriage.dundermifflin.com	CNAME	5 minutes
www2.dundermifflin.com.	saddle.dundermifflin.com.	CNAME	5 minutes
ftp.dundermifflin.com.	platen.dundermifflin.com.	CNAME	5 minutes
files.dundermifflin.com.	roller.dundermifflin.com.	CNAME	7 days
 ```
## Submission Requirements

Please submit your notes as a .txt or .pdf file.
A DHCP server must be set up on Machine A for the other hosts to pull statically assigned ip addresses based on mac address for all other machines in your network.

All clients (B, C, D, E, and F) should be configured to pull network configuration via dhcp.

All local servers and the vpn should be able to reach ssh (port 22) on Machine F at address 100.64.N.5.

Machine F should have the same user/group/permissions configuration as machine B.  Machine F should periodically (e.g. hourly) pull a copy of the web content from /var/www/ on machine B.  cron must be used for this.

The dns server must be reachable and resolve dns requests for names external to D-M.  It must also act as an authoritative server for the dundermifflin.com. domain

All names in the table above must be valid, point to the proper location, with the appropriate record type and time to live.

The hostnames on your machines must change to those outlined in the table above.  The old names, machine a,b,c,d, e, and f, should still be valid on your DNS server.

The dhcp server running on router should push both the resolving dns server (100.64.N.4) and search path (dundermifflin.com) to all clients.

 

## Hints & Troubleshooting

The existing public key in /root/.ssh/authorized_keys labeled saclass-admins@donotremove must remain on all production machines, otherwise I won't be able to login and grade your work.

If machine E cannot resolve dns queries with named running on machine D, ensure that allow-query { any; }; is set in the global bind options directive, right under listen-on {};.

Use the named-checkconf and named-checkzone programs to identify syntax errors in configuration files.

If bind appends a domain name to your hostname twice; e.g., chase.dundermifflin.com.dundermifflin.com., you likely forgot a dot somewhere in a zone file.

If you get a srvfail error message or no results for dundermifflin.com at all then double check your filesystem permissions on the zone file in /var/named/.  The user named must be able to read all zone files.

 


