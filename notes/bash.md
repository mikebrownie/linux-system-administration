# Bash

You can just use `man cmd` to get a better view but for quick reference.

## Basics

Remove
```bash
rm
```

Change directory
```bash
cd
```

Copy
```bash
cp source dest
```

Move
```bash
mv src dest
```

Make empty file
```bash
touch
```

List contents of directory. Sort based on time with `-t`, long listing of all files `-al`
```bash
ls
```

Find all passwds
```bash
find / -name passwd
```

Find files edited in the last day.
```bash
find ~ -mtime -1
```

Find files created in the last day w/ name foo.
```bash
find ~ -ctime -1 -name foo
```

Delete log files not updated in the last 7 days
```bash
find /var/log -mtime +7 -exec rm {} \;
```

## Some commands

Nuke your pc:
```bash
rm -rf *
```

## Before doing something crazy

Get user id:
```bash
whoami
```

Print working directory (where am I)
```bash
pwd
```

Information about your system
```bash
uname -a
```

## Networking

Interface config, being replaced by the ip command
```bash
ifconfig
```

Who's logged in (don't kick people off)
```bash
who
```

Take a look at the kernel.
```bash
cat /proc/meminfo
```

## Environment


Print all env variables
```bash
set
```

More is a pager that can handle a good amount of data.
```bash
set | more
```

Print env variable
```
echo $PATH
```

'noclobber' won't allow you to silently clobber variables
```bash
set -o noclobber
```

?
```
set | grep SHELLOPTS
```

## Time and date

display the date
```bash
date
```

## Cut and awk

Cuts output. `-d` delimiter. `-f` which field.

awk is even better

- `ps -ef` displays running process. `-ef to get a lot of info`

Can be used for vertical splitting
```bash
ps -ef | awk '/ssh/ { print $2 }'
```

## GREP

generalized regular expression printer. Just man page it tbh.

## sed

stream editor. Useful for replacing text in a line
flags:
- s substitute
- e expression
- g global
- r regex

## Conditionals

### Exit status $?

Every program returns an exit status (0 is good)

```bash
ls ; echo $?
```

```bash
touch /root/foo ; echo $?
```

- a && b : execute b if a was successful
- a && b : execute b regardless of a's success

## String interpolation

Double and single quotes distinguish between iterpolable strings and literals

```bash
foo="bar"
echo 'the variable is $foo'
echo 'the value of foo is $foo'
```

## Permissions

List permission of a file
```bash
ls -al
```
Dashes mean no permission, r=read, w=write, x=execute
ex: rwxrw-r-- user can rwx, group can rw, any can read 
- R 4
- W 2
- X 1

### Setting permissions

chmod can be used to change the modes, i.e. the permissions of a file

```bash
chmod 755 /tmp/file
```
give RWX
