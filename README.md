
Simple cross-patform rsync backup
=================================

Single-file backup script which lives in the target directory alongside with data and points to actual backup storage.

Backup always simple as invoking `./backup.sh`

NOTE: this is **mirror-style backup**, everything you have deleted in your working copy would be removed on a backup storage during sync (`rsync --delete` option). It's assumed your are using hard links snapshots on a backup storage if you'd like keep previous files versions.

Snapshot tool `snapshot.sh` would create new snapshot for you once backup finished. Just put `snapshot.sh` into directory alongside with `backup.sh`. Snapshots made in common rsync+hardlinks way. They aren't expand storage capacity, but you have to use filesystem with hardlinks support like `ext4`.

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

Install rsync-3.1.2+, openssh, realpath, tee. Target storage filesystem with hard links support.

All this pre-installed in common desktop Linux distros.

## Install rsync and ssh on Windows

(tested on Windows 7)

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

 * Copy `backup-sample.sh` into target directory, rename as you like. Let's assume it `backup.sh`.
 * Open `backup.sh` and specify correct values for `BACKUP_SERVER` and `STORAGE`.

Examples:

```bash
BACKUP_SERVER="user@backup-server"
STORAGE="family_photos"
```

 * Invoke `backup.sh` in `--dry-run (-n)` mode. It's enabled by default by `DEBUG_ARGS=` param.
 * Remove `--dry-run (-n)` option by commenting `DEBUG=` param.

### Enable snapshots

 * Copy `snapshot.sh` into target directory. That's it. You should keep name of the tool according `SNAPSHOT_TOOL=` param in your `backup.sh`. It's `snapshot.sh` by default.

### Windows launcher as .sh association

 * copy appropriate 32/64 version of `sh_launcher{32/64}.cmd` as `C:\msys{32/64}\sh_launcher.cmd`
 * apply appropriate 32/64 version of `msys2_32_sh.reg`

## Perform backup

 * Run `backup.sh`
 * Follow instructions

## Exclude paths from backup

Create file named `backup-ignore`. See `backup-ignore-sample` as reference.
