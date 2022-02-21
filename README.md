
Simple cross-patform rsync backup
=================================

Single-file backup script which lives in the target directory alongside with data and points to actual backup storage.

Backup always simple as invoking `./backup.sh`

## Few concepts

`CONTAINER` is a bunch of data which you'd like to keep together, like your documents or photos.

`STORAGE` is a place on the backup disk/server keeping multiple **containers**.

By default **container** name is the current directory name, but you can override it by `CONTAINER=` option.

## Examples

```
./backup.sh   # perform backup
```

```
./backup.sh --verbose   # append custom attributes to rsync
```

## Prerequisites for Server and Client

install rsync-3.1.2+

## Install rsync and ssh on Windows

 * Download from http://msys2.org/
 * Follow instructions for update packman
 * Install rsync and ssh 

```bash
$ pacman -S rsync openssh
```

## Setup ssh config

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

## Setup backup config

 * Copy `backup-sample.sh` into target folder as `backup.sh`.
 * Open `backup.sh` and specify correct values for `BACKUP_SERVER` and `STORAGE`

Examples:

```bash
BACKUP_SERVER="user@backup-server"
STORAGE="family_photos"
```

 * test in `--dry-run (-n)` mode
 * remove `--dry-run (-n)` option by commenting DEBUG= variable

### Windows launcher as .sh association

 * copy appropriate 32/64 version of `sh_launcher{32/64}.cmd` as `C:\msys{32/64}\sh_launcher.cmd`
 * apply appropriate 32/64 version of `msys2_32_sh.reg`

## Perform backup

 * Run `backup.sh`
 * Follow instructions

## Exclude paths from backup

Create file named `backup-ignore`
