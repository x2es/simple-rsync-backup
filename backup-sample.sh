#!/bin/bash

#
# https://github.com/x2es/simple-rsync-backup
# v1.2.0
# 

# test your configuration and comment out DEBUG_ARGS after
DEBUG_ARGS="--dry-run"

# comment BACKUP_SERVER for local copy
BACKUP_SERVER="user@backup.coolcab.org"

# NOTE: non-absolute path points to user's home
STORAGE="backup/storage"

# by default CONTAINER is the name of the current directory
# CONTAINER="custom-name"

LOG_FILE="./backup.log"

# COMPRESS="--compress" # old compress
COMPRESS="-zz" # works with rsync-3.1.2

# prserve hard links
# HARDLINKS="--hard-links"

# Append your custom rsync args by setting CUSTOM_ARGS=
# or by passing params to this script
# CUSTOM_ARGS=""

#                    #
# --- CONFIG END --- #
#                    #

[[ -z "$CONTAINER" ]] && CONTAINER="$(basename $(pwd))"
CONTAINER_PATH="$STORAGE/$CONTAINER"

[[ ! -z "${@}" ]] && CUSTOM_ARGS="$CUSTOM_ARGS ${@}"

[[ ! -z "$BACKUP_SERVER" ]]             && BACKUP_TARGET="$BACKUP_SERVER:"
[[ "${CONTAINER_PATH:0:1}" != "/" ]]    && BACKUP_TARGET="${BACKUP_TARGET}~/"
BACKUP_TARGET="${BACKUP_TARGET}${CONTAINER_PATH}/"

EXCLUDE_LIST="./backup-ignore"
EXCLUDE_ARG=""
[[ -f $EXCLUDE_LIST ]] && EXCLUDE_ARG="--exclude-from=$EXCLUDE_LIST --delete-excluded"

echo "Backup:"
[[ ! -z "$DEBUG_ARGS" ]] && echo "  DEBUG: $DEBUG_ARGS"

TARGET_NODE="$BACKUP_SERVER"
[[ -z "$TARGET_NODE" ]] && TARGET_NODE="local"

echo "        dir: `pwd`"                
echo "         to: $TARGET_NODE"
echo "  container: $CONTAINER_PATH"
[[ ! -z "$CUSTOM_ARGS" ]] && echo "custom args: $CUSTOM_ARGS"

if [[ "$EXCLUDE_ARG" != "" ]]; then
  echo
  echo "<<<< exclude: <<<<"
  cat $EXCLUDE_LIST
  echo ">>>>>>>>>>>>>>>>>>"
fi

echo
echo "(press ENTER for continue / Ctrl+C for cancel)"
read

COMMON_ARGS="$DEBUG_ARGS --archive $HARDLINKS $COMPRESS $CUSTOM_ARGS --stats --progress --itemize-changes"

rsync $COMMON_ARGS --recursive --log-file=$LOG_FILE $EXCLUDE_ARG --delete . $BACKUP_TARGET

# Sync logfile
[[ ! -z "$DEBUG_ARGS" ]] && echo "SKIP: $LOG_FILE didn't sync due DEBUG_ARGS=$DEBUG_ARGS" || rsync $COMMON_ARGS $LOG_FILE $BACKUP_TARGET

echo
echo "Done! (press ENTER to exit)"
read
