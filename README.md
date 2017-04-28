
Simple cross-patform rsync backup
=================================

## Setup on Server

### Use rsync-3.1.2+

On Ubuntu 14.04 it needed to be complied from sources.

 * Download latest from https://rsync.samba.org/ and unpack

```bash
$ sudo apt-get install checkinstall
$ ./configure
$ make
$ sudo apt-get remove rsync
$ sudo checkinstall
```

## Install & Setup on Client

### Install on Windows

 * Download from http://msys2.org/
 * Follow instructions for update packman
 * Install rsync and ssh 

```bash
$ pacman -S rsync openssh
```

### Setup ssh config

 * Create ssh key 

```bash
$ ssh-keygen
```

 * Create shortcut to backup server in `.ssh/config`

```ssh-config
Host backup-server
  HostName backup.srv
  Port 22
```

 * Use `ssh-copy-id` to copy public key to backup server

```bash
$ ssh-copy-id user@backup-server
```

### Setup backup config

 * Copy `backup-sample.sh` into target folder as `backup.sh`.
 * Open `backup.sh` and specify correct values for `BACKUP_SERVER` and `CONTAINER`

Examples:

```bash
BACKUP_SERVER="user@backup-server"
CONTAINER="family_photos"
```

 * test in `--dry-run (-n)` mode
 * remove `--dry-run (-n)` options

#### Windows launcher as .sh association

 * copy appropriate 32/64 version of `sh_launcher{32/64}.cmd` as `C:\msys{32/64}\sh_launcher.cmd`
 * apply appropriate 32/64 version of `msys2_32_sh.reg`

## Perform backup

 * Run `backup.sh`
 * Follow instructions

## Exclude paths from backup

Create file named `backup-ignore`
