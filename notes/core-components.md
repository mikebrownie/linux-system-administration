# Core Comonents of the OS

## The Filesystem Structure

Everything starts from the root "/"

### Conventions

Some conventions get violated, but typically:

- `/bin` executable binaries.
- `/home` user files are kept here
- `/usr/bin` user space binaries
- `/var` Variable length data, like logs. Anything that varies in size
- `/etc` configuration data

## Anatomy of Shell

- Typically more useful for automation compared to GUIs
- Many different shells, but bash is pretty standard

```bash
user@host:/home$ command arg1 arg2 arg3
```

### File Descriptiors

Every process gets 3 pipes automatically.

#### 0 Standard out (STDOUT)

Prints to the screen

#### 1 Standard in (STDIN)

Reads from the keyboard, user input

#### 2 Standard error (STDERR)

Where error messages are written to

### Redirection

We can direct output into a file with `>`. Ex: redirect STDOUT to file 

```sh
0 > file.txt
```

We can pipe output from **process a** to **process b** with the pipe, `|`. Ex: find data in file.txt: 

```sh
cat file.txt | grep 'data'
```

### Text Editors

Useful for more complex scripting.

#### VIM

Any system with EMACS will have vim. Professor reccomends studying vim at http://vim-adventures.com

#### NANO

"Or wimp out entirely and use ~emacs~ **nano**
