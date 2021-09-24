# Configuration Management

Using [puppet](https://puppet.com/)

## Tasks

1) Set up accounts on all machines for all D-M employees and yourself.  Each user should have a username of the form first-initial last-name, password, unique uid, unique gid, /path/to/login/shell, and /path/to/home/directory/.  The grading script is very strict about user names.  usernames must be all lowercase with no punctuation. Account data must be the same on all machines.  The Gecos field does not matter.

2) Home directories must exist for all users.  All home directories on all machines must be initialized with the contents of /etc/skel/ and owned by the appropriate user and user-private-group.

3) Create secondary groups for managers, sales, and accounting. The grading script checks for these exact names.  Add the appropriate users to these groups based on the org chart.

4) Create a shared directory under /home/ on the file server (machine E) for each secondary group you created, with permissions such that only the user owner and members of the group owner can read, write, and execute files.  New files and folders created under these shared directories must inherit the group id of the parent directory, not that of the process that creates them.

5) Use exact names for users mscott, dschrute, jhalpert, pbeesly, abernard, amartin, kkapoor, omartinez, dphilbin, tflenderson, kmalone, plapin, shudson, mpalmer, cbratton.

## Approach

First, I wrote a python script, `gen_users.py`, to generate a puppet file, `users.pp`, with all the users, groups, and home 
directories.

Python3 was not enough, so I
  - Manually added in some group fields to `users.pp` according to the org chart. 
  - Manually added in some shared folders to `users.pp`.     
  - Created a `groups.pp` file with group declarations.

## Applying to remote machine

1) I scped the .pp files over to the remote machine

```bash
scp groups.pp root@100.64.0.2:/etc/puppet/groups.pp
scp users.pp root@100.64.0.2:/etc/puppet/users.pp
```

2) From the remote machine, I sequentially applied groups.pp and users.pp

```bash
puppet apply /etc/puppet/groups.pp
puppet apply /etc/puppet/users.pp
```

3) Repeated steps 1 and 2 for all machines.
4) For machine E, create shared directory with shared.pp file

```bash
puppet apply /etc/puppet/shared.pp
```

