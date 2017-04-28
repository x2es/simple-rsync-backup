#!/bin/bash

#
# https://github.com/x2es/simple-rsync-backup
# v1.1.0
# 

BACKUP_SERVER="x2es@backup.coolcab.org"
CONTAINER="backup/container"
LOG_FILE="./backup.log"

BACKUP_TARGET="$BACKUP_SERVER:~/$CONTAINER"

EXCLUDE_LIST="./backup-ignore"
EXCLUDE_ARG=""
[[ -f $EXCLUDE_LIST ]] && EXCLUDE_ARG="--exclude-from=$EXCLUDE_LIST --delete-excluded"

echo "Backup:"
echo "        dir: `pwd`"                
echo "         to: $BACKUP_SERVER"      
echo "  container: $CONTAINER"

if [[ "$EXCLUDE_ARG" != "" ]]; then
  echo
  echo "<<<< exclude: <<<<"
  cat $EXCLUDE_LIST
  echo ">>>>>>>>>>>>>>>>>>"
fi

echo
echo "(press ENTER for continue / Ctrl+C for cancel)"
read

# COMPRESS="--compress" # old compress
COMPRESS="-zz" # works with rsync-3.1.2

COMMON_ARGS="--dry-run --archive $COMPRESS --stats --progress --itemize-changes "

rsync $COMMON_ARGS --recursive --log-file=$LOG_FILE $EXCLUDE_ARG --delete   .           $BACKUP_TARGET
rsync $COMMON_ARGS                                                          $LOG_FILE   $BACKUP_TARGET

echo
echo "Done! (press ENTER to exit)"
read
