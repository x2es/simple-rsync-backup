
Simple cross-patform rsync backup
=================================

## Install & Setup

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
  User backup_user
```

 * Use `ssh-copy-id` to copy public key to backup server

```bash
$ ssh-copy-id backup-server
```

### Setup backup config

 * Copy `backup.sh` and `backup-launcher.cmd` (windows only) into target folder.
 * Open `backup.sh` and specify correct values for `BACKUP_SERVER` and `CONTAINER`

Examples:

```bash
BACKUP_SERVER="backup-server"
CONTAINER="family_photos"
```

If no .ssh/config shortcuts defined

```bash
BACKUP_SERVER="user@some.srv"
CONTAINER="family_photos"
```

 * test in `--dry-run (-n)` mode
 * remove `--dry-run (-n)` options

## Perform backup

 * Run `backup.sh` (Linux/Mac) or `backup-launcher.cmd` (Windows)
 * Follow instructions
