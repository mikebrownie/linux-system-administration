# Lab 5 - IP Networking

## Initial Set U[

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

 

