# Scripting

__see also__

- [bash commands](https://github.com/mikebrownie/linux-system-administration/blob/main/notes/bash.md)

Useful for gluing programs, monitoring, automating tasks


First line specifies shell to use

```bash
#!/bin/bash
```

## For-loop Example

```bash
#!/bin/bash

for loop in `ls`
do
  if [ -f $loop ]
  then
    echo "$loop is a regular file"
  else
    echo "$loop is a not regular file"
  fi
done
```

- backticks around `ls` feed output of the command to the loop
- `[ -f loop ]` checks if current value is a regular file


## While-loop Example

While i is less than i, print i, sleep 1 second, add one to i.
```bash
#!/bin/bash

i=0
while [ $i -lt 10 ]
do
  echo "i=$i"
  date
  sleep 1
  i=`expr $i + 1`
```
