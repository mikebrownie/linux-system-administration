Big shoutout to [this guide on LVM](https://web.archive.org/web/20190503083414/https://www.debian-administration.org/article/410/A_simple_introduction_to_working_with_LVM)

# Tasks:

## Import the physical volume (pvcreate)

First, initialize /dev/sdb as a physical volume.

```sh
pvcreate /dev/sdb
```

You should get output like:

```sh
Physical volume "/dev/sdb" successfully created.
```

## Create a new volume group (vgcreate)

Next, we will create a new volume group named 'new'

```sh
vgcreate new /dev/sdb
```

Output:

```sh
Volume group "new" successfully created
```

Double check with vgscan:

```sh
vgscan
Reading volume groups from cache.
Found volume group "centos" using metadata type lvm2
Found volume group "new" using metadata type lvm2
```

## Create the logical volumes (lvcreate)

Create two logical volumes named home (4GB) and tmp (1GB).

```sh
lvcreate -n tmp --size 1g new
```
&
```sh
lvcreate -n home --size 4g new
```

You can view them with:

```sh
lvdisplay
```

Output:

```
  --- Logical volume ---
  LV Path                /dev/new/tmp
  LV Name                tmp
  VG Name                new
  LV UUID                8fxrR4-9IFr-b0pt-iheo-nYYF-14ZR-v2lfXU
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/new/home
  LV Name                home
  VG Name                new
  LV UUID                uKmhrT-DJrL-LE0U-rlKg-wZgb-E9xO-RCRqWc
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                4.00 GiB
  Current LE             1024
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:3
```

## Make two xfs filesystems (mkfs)

We will make two xfs filesystems

```sh
mkfs.xfs /dev/new/home
```
&
```sh
mkfs.xfs /dev/new/tmp
```

## Mount the new filesystems to temporary mount points (mount)

Set up a temp file system for mounting, here is mine:

```sh
ls -R new/
new/:
home  tmp

new/home:

new/tmp:
```

Then mount

*The nodev mount option specifies that the filesystem cannot contain special devices: This is a security precaution. You don't want a user world-accessible filesystem like this to have the potential for the creation of character devices or access to random device hardware.* [source](https://serverfault.com/questions/547237/explanation-of-nodev-and-nosuid-in-fstab)

*The nosuid mount option specifies that the filesystem cannot contain set userid files. Preventing setuid binaries on a world-writable filesystem makes sense because there's a risk of root escalation or other awfulness there.* [source](https://serverfault.com/questions/547237/explanation-of-nodev-and-nosuid-in-fstab)

```sh
mount /dev/new/tmp new/tmp -o nodev,nosuid,noexec	

```

```sh
mount /dev/new/home new/home -o nodev
```

## Copy the existing contents from the old disk to the new filesystems (cp or tar)

Here we will use cp to copy over the contents

```
cd /home

cp -a . /root/new/home/
```

And for tmp

```
cd /tmp
cp -a . /root/new/tmp
```
## Update /etc/fstab so the new filesystems are persistent across a reboot

Edit /etc/fstab

```sh
vi /etc/fstab
```

Add these entries:

```sh
/dev/new/tmp /tmp       xfs     nodev,nosuid,noexec     0 2
/dev/new/home /home     xfs     nodev   0 2
```

## Resize the filesystem to actually fill the volume:

Lastly, I will delete unmount and delete the file on the root partition to actually free up space

```sh
unmount /dev/new/home
rm -rf home/
```

There is now more free space on the root partition.

```sh
[root@machinee /]# df -h
Filesystem               Size  Used Avail Use% Mounted on
devtmpfs                 233M     0  233M   0% /dev
tmpfs                    244M     0  244M   0% /dev/shm
tmpfs                    244M   13M  231M   6% /run
tmpfs                    244M     0  244M   0% /sys/fs/cgroup
/dev/mapper/centos-root  6.0G  3.9G  2.2G  65% /
/dev/sda1                497M   97M  400M  20% /boot
tmpfs                     49M     0   49M   0% /run/user/0
```
