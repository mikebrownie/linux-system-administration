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

 


# Part 1 DHCP

Log into machine each machine, get mac address

```

ip a

```

link/ether 00:50:56:85:29:0e

  

Now on machine A, edit the dhcpd.conf to set up a DHCP server for the other hosts to pull statically assigned ip addresses based on mac address

  

```

vi /etc/dhcp/dhcpd.conf

```

  

Add the following lines

```

# Internal Network Switch0

subnet 10.21.32.0 netmask 255.255.255.0 {

option routers 10.21.32.1;

option domain-name-servers 100.64.2.4;

option domain-name "dundermifflin.com";

range 10.21.32.2 10.21.32.254;

}

host machinee {

hardware ethernet 00:50:56:85:05:84;

fixed-address 10.21.32.2;

option host-name "roller";

}

  

subnet 100.64.2.0 netmask 255.255.255.0 {

option routers 100.64.2.1;

option domain-name-servers 100.64.2.4;

option domain-name "dundermifflin.com";

range 100.64.2.2 100.64.2.254;

}

host machineb {

hardware ethernet 00:50:56:85:f8:be;

fixed-address 100.64.2.2;

option host-name "carriage";

}

host machinec {

hardware ethernet 00:50:56:85:00:22;

fixed-address 100.64.2.3;

option host-name "platen";

}

host machined {

hardware ethernet 00:50:56:85:61:77;

fixed-address 100.64.2.4;

option host-name "chase";

}

  

host machinef {

hardware ethernet 00:50:56:85:20:0e;

fixed-address 100.64.2.5;

option host-name "saddle";

}

```

Restart dhcpd to apply changes

```

systemctl restart dhcpd

```

  

Make sure dhcpd survives reboot:

  

```

systemctl enable dhcpd

```

On each machine:

  

Modify /etc/sysconfig/network-scripts/ifcfg-ens192

```

TYPE=Ethernet

BOOTPROTO=dhcp

ONBOOT=yes

NETWORKING=yes

```

  

Edit contents of /etc/hostnames to only `localhost.localdomain`

  
  

Send changes to all machines with scp

```

scp /etc/sysconfig/network-scripts/ifcfg-ens192

100.64.2.x:/etc/sysconfig/network-scripts/ifcfg-ens192

```

  

and

  

```

scp /etc/hostname 100.64.2.13:/etc/hostname

```

  
  

No entries in leases?

```

cat /var/lib/dhcpd/dhcpd.leases

```

  
  
  

## Part 2 DNS

  

Start by manually setting DNS to install required packages

```

vi /etc/sysconfig/network-scripts/ifcfg-eno16780032

```

  

Add `DNS1=8.8.8.8`

  

Apply changes

```

systemctl restart network

```

Now you can resolve hostnames external to the LAN

  

Add these lines to`/etc/named.conf`

```

allow-query { localhost; 100.64.2.0/24; 10.21.32.0/24; };

listen-on port 53 { 127.0.0.1; 100.64.2.0/24; 10.21.32.0/24; };

```

  

Apply changes

```

[root@chase ~]# systemctl enable named

[root@chase ~]# systemctl restart named

```

  
  

Zone file

```

$TTL 1440

@ IN SOA chase.dundermifflin.com. root.dundermifflin.com. (

1001 ;Serial

3H ;Refresh

15M ;Retry

1W ;Expire

5M ;Minimum TTL

)

dundermifflin.com.  3600  IN  NS  chase.dundermifflin.com.

router.dundermifflin.com.  3600  IN  A  100.64.2.1

carriage.dundermifflin.com.  3600  IN  A  100.64.2.2

platen.dundermifflin.com.  3600  IN  A  100.64.2.3

chase.dundermifflin.com.  3600  IN  A  100.64.2.4

roller.dundermifflin.com.  3600  IN  A  10.21.32.2

saddle.dundermifflin.com.  3600  IN  A  100.64.2.5

machinea.dundermifflin.com.  604800  IN  CNAME  router.dundermifflin.com.

machineb.dundermifflin.com.  604800  IN  CNAME  carriage.dundermifflin.com.

machinec.dundermifflin.com.  604800  IN  CNAME  platen.dundermifflin.com.

machined.dundermifflin.com.  604800  IN  CNAME  chase.dundermifflin.com.

machinee.dundermifflin.com.  604800  IN  CNAME  roller.dundermifflin.com.

machinef.dundermifflin.com.  604800  IN  CNAME  saddle.dundermifflin.com.

; dundermifflin.com.  300  IN  CNAME

dundermifflin.com. 3600 IN A 100.64.2.4

carriage.dundermifflin.com.

www.dundermifflin.com.  300  IN  CNAME  carriage.dundermifflin.com.

www2.dundermifflin.com.  300  IN  CNAME  saddle.dundermifflin.com.

ftp.dundermifflin.com.  300  IN  CNAME  platen.dundermifflin.com.

files.dundermifflin.com.  604800  IN  CNAME  roller.dundermifflin.com.

```

  
  

Append to /etc/named.conf

```

zone "dundermifflin.com" IN {

type master;

file "/var/named/dundermifflin.com";

allow-update { none; };

};

```

  

Install Dig on machine B

```

yum install bind-utils

```

  

Check that dns is working with dig

```

[root@carriage ~]# dig @100.64.2.4 www.dundermifflin.com

; <<>> DiG 9.11.4-P2RedHat-9.11.4-26.P2.el7_9.7 <<>> @100.64.2.4 www.dundermifflin.com

; (1 server found)

;; global options: +cmd

;; Got answer:

;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31056

;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:

; EDNS: version: 0, flags:; udp: 4096

;; QUESTION SECTION:

;www.dundermifflin.com. IN A

;; ANSWER SECTION:

www.dundermifflin.com. 300 IN CNAME carriage.dundermifflin.com.

carriage.dundermifflin.com. 3600 IN A 100.64.2.2

;; AUTHORITY SECTION:

dundermifflin.com. 3600 IN NS chase.dundermifflin.com.

;; ADDITIONAL SECTION:

chase.dundermifflin.com. 3600 IN A 100.64.2.4

;; Query time: 1 msec

;; SERVER: 100.64.2.4#53(100.64.2.4)

;; WHEN: Sun Oct 31 14:40:29 MDT 2021

;; MSG SIZE rcvd: 125

```

  
  

There is an issue with adding a NS and CNAME record to the domain dundermifflin.com.

  

## Part 3 Backup HTTP Rsycnc & Crontab

  

First set up passwordless auth between B and F

  

```

ssh-keygen

```

  

Copy key contents over from B

```

ssh-copy-id root@100.64.2.5

```

  

We will sync every minute using crontab

```

crontab -e

```

  

https://www.geeksforgeeks.org/crontab-in-linux-with-examples/

```

* * * * * rsync -av /var/www root@100.64.2.5:/var/.

* * * * * rsync -av /etc/httpd/ root@100.64.2.5:/etc/httpd/.

```
