# Access Control Lab

## Email to Jim Halpert

_____

    To: Jim Halpert

    Subject: Request for full administrative access
____
Hello Jim,


While allowing you full administrative access may make our lives easier, I can't grant this priviledge as it poses a threat to the security of our network. I do appreciate you stepping up and offering help in "the event you out of town I might need to access employee files or help them out with other things." As a matter of fact, I would love to teach you more about my job and the considerations that go into being a linux system administrator. If you are up for it, we can meet with Michael Scott tomorrow afternoon and discuss the possibility of a weekly training session! 

In the meantime, please avoid sending your password to anyone! You should not store your passwords in plaintext anywhere. Imagine if I did grant your request for super user privilidge, and someone with your password used it to steal our sales leads, or worse, delete our servers! Michael Scott would not be happy.


Sincerely,

Brown, M.

System Administrator.
____


## Password policy

- New passwords are at least 10 characters long, and contain at least 2 digits, 2 uppercase, and 1 non alphanumeric character.
- Never disclose passwords to anyone, for any reason.
- Passwords must be changed every year (automatically enforced).
- Use the built in chrome password manager to store passwords.

## Tickets

### Meredith Palmer

From: Meredith Palmer

I can log in to my account on our ftp server, but I can no longer restart vsftp as I used to using the systemctl restart vsftpd thingy or modify any files under /var/ftp/.  I have supplier lists I need to update today.  Please fix it now!!!!


### Pam Beasly

From: Pam Beesly

I just wanted to let you know that neither Kelly Kapoor, Andy Bernard, nor I can update the website anymore.  We have some changes to make soon so it would be wonderful if we could be granted access to modify the files on our web server under /var/www/dundermifflin/ and restart httpd like we used to!  Thank you very much for your help!

### Dwight Schrute

From: Dwight Schrute

Your clever attempt to gain control of our Linux systems has worked, but only temporarily.  Michael Scott will confirm that I must be granted administrative access on all servers.  Please grant me access today, or else.


### Jim Halpert
From: Jim Halpert

Hey, quick question… can you grant me full administrative access on all of the servers?  In the event that you are out of town I might need to access employee files or help them out with other things.  My password is Dund3rMifflin if that makes it easier for you.

#### DENIED

## Requirements + Notes

1) Please submit your lab notes as a pdf,including the password protection policy you propose for our D-M branch office, and your e-mail to Jim.

2) Meredith Palmer must be able to run systemctl restart vsftpd (not start/stop, just restart) on Machine C.  She must be able to read and modify all files and folders under /var/ftp/.

First we edit sudoers using a secure editor (vim leaves files laying around)

```shell
visudo 
```
Then, add this to the end
```shell
mpalmer ALL = (ALL) NOPASSWD: /bin/systemctl restart vsftpd
```
She can now run sudo systemctl restart vsftpd

We can fix her file permissions using:
```shell
chgrp -R mpalmer /var/ftp/
chmod -R 775 /var/ftp/
```

3) Pam Beesly, Kelly Kapoor, and Andy Bernard must be allowed to restart the http daemon (not start/stop, just restart) on machine B through sudo, and modify all files under /var/www/dundermifflin/ without affecting the user apache’s ability to read them.

Use `visudo` to securely edit /etc/sudoers. Then add

```
pbeesly ALL=(ALL) /usr/bin/systemctl restart httpd
abernard ALL=(ALL) /usr/bin/systemctl restart httpd
kkapoor ALL=(ALL) /usr/bin/systemctl restart httpd
```

Next, we handle permission first by adding the 3 to a secondary group:

```
groupadd webdevs
usermod -a -G webdevs pbeesly
usermod -a -G webdevs abernard
usermod -a -G webdevs kkapoor
```

And next setting their group as owners of the directory
```
chown -R :webdevs /var/www/dundermifflin/
```

Then setting correct permissions for reading and writing
```
chmod -R 775 /var/www/dundermifflin/
```


4) The default umask must be adjusted on machines A, C, D, and E so that when new directories are created the owner can read, write, and execute, the group can read, write and execute, and others have no access.  You need to do either the reading from the prior homework or some independent research to identify how to do this.

umask disallows permissions, so here we need to set the umask to the inverse of what is would be for chmod.
```shell
vim /etc/profile.d/umask.sh
```

and add this line to set umask for users with gid greater than 1999
```
if [ $UID -gt 199 ]; then
        umask 007
fi
```

Do so on A, C, D, and E

**Issue on machine E**

5) Access on each server should be restricted such that only users who need to are allowed to log in.  The one exception is all users should be allowed to log in on machine E.  Access restriction should be imposed using pam_access so that the /etc/passwd and /etc/shadow files stay consistent across all machines.
IMPORTANT: You must explicitly allow root access via SSH.  While it is certainly more secure to disallow direct access to root remotely, access to root must be maintained so we can grade your machines.

Note: On Redhat based distros it must be enabled by editing /etc/pam.d/system-auth and adding account required pam_access.so.
```
# Enabling PAM_ACCESS
account     required      pam_access.so
```

Now we can set rules by editing `/etc/security/access.conf`. These are the configurations for each machine.

A) Machine A is a router, so only admins and mscott can login
```
+:root:ALL
+:dschrute:ALL
+:mscott:ALL
+:mbrown:ALL
-:ALL:ALL
```

B) 
```
+:root:ALL
+:dschrute:ALL
+:mscott:ALL
+:mbrown:ALL
+:abernard:ALL
+:kkapoor:ALL
+:pbeesly:ALL
-:ALL:ALL
```

C)
```
+:root:ALL
+:dschrute:ALL
+:mscott:ALL
+:mbrown:ALL
-:ALL:ALL
```

D)
```
+:dschrute:ALL
+:mscott:ALL
+:mbrown:ALL
+:root:ALL
-:ALL:ALL
```
E) No changes necessary

6) Sudo access to all commands, on all machines, should be granted to responsible users who have specifically requested it.  This includes your own personal account.

On all machines, run:

```
useradd -m mbrown
usermod -a -G wheel mbrown
usermod -a -G wheel dschrute
```

7) Michael Scott should be allowed to shut all servers down with no less than 2 hours notice to other users (see man shutdown).  He should be limited to shutting them down, not restarting.  He should also be allowed to cancel a pending shutdown.

Once again, use `visudo` to edit /etc/sudoers. Then add

```
mscott ALL=(all) /sbin/shutdown +1[2-9][0-9]
mscott ALL=(ALL) /sbin/shutdown +[1-9][0-9][0-9]
mscott ALL=(ALL) /sbin/shutdown +[1-9][0-9][0-9][0-9]
mscott ALL=(ALL) /sbin/shutdown +[1-9][0-9][0-9][0-9][0-9]
mscott ALL=(ALL) /sbin/shutdown -c
mscott ALL=(ALL) /sbin/halt
```

8) Password changes must be enforced on all servers such that pam ensures that new passwords are at least 10 characters long, and contain at least 2 digits, 2 uppercase, and 1 non alphanumeric character.


Open pwquality.conf: 
```vim /etc/security/pwquality.conf```

Add in rules:
```
minlen = 11
dcredit = -2
ucredit = -2
ocredit = -1
```

Do for all machines

