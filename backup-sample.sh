#!/bin/bash

BACKUP_SERVER="vagrant@192.168.22.1"
CONTAINER="container_1"
LOG_FILE="./backup.log"

COMPRESS="--compress" # old compress
# COMPRESS="-zz" # new compress

echo "Backup current dir to $BACKUP_SERVER into $CONTAINER (press ENTER for continue / Ctrl+C for cancel)"
read

rsync --dry-run --recursive --archive $COMPRESS --stats --progress --itemize-changes --log-file=$LOG_FILE --exclude=$LOG_FILE --delete . $BACKUP_SERVER:~/$CONTAINER
rsync --dry-run --archive $COMPRESS --stats --progress --itemize-changes $LOG_FILE $BACKUP_SERVER:~/$CONTAINER

echo
echo "Done! (press ENTER to exit)"
read
