#!/bin/bash

#
# https://github.com/x2es/simple-rsync-backup
# v1.3.0
# 

# test your configuration and comment out DEBUG_ARGS after
DEBUG_ARGS="--dry-run"

# comment BACKUP_SERVER for local copy
BACKUP_SERVER="user@backup.coolcab.org"

# NOTE: non-absolute path points to user's home
STORAGE="backup/storage"

# by default CONTAINER is the name of the current directory
# CONTAINER="custom-name"

LOG_FILENAME="backup.log"
EXCLUDE_FILENAME="backup-ignore"

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

function die() {
  echo "FATAL ERROR: ${@}"
  exit 1
}

SNAPSHOT_WORK_COPY="recent"
SNAPSHOT_TOOL="snapshot.sh"

[[ ! -z "${@}" ]] && CUSTOM_ARGS="$CUSTOM_ARGS ${@}"

EXEC_PATH="$(dirname $(realpath -s $0))"
LOG_FILE="$EXEC_PATH/$LOG_FILENAME"
EXCLUDE_LIST="$EXEC_PATH/$EXCLUDE_FILENAME"
SNAPSHOT_TOOL_LOCAL_PATH="$EXEC_PATH/$SNAPSHOT_TOOL"

[[ -z "$CONTAINER" ]] && CONTAINER="$(basename $EXEC_PATH)"
CONTAINER_PATH="$STORAGE/$CONTAINER"

# Treat non-absolute paths as home-based
if [[ "${CONTAINER_PATH:0:1}" != "/" ]]; then
  # due issue with expansion "~" for not yet existing paths
  [[ ! -z "$BACKUP_SERVER" ]] && CONTAINER_PATH="~/$CONTAINER_PATH" || CONTAINER_PATH="$HOME/$CONTAINER_PATH"
fi

# Once snapshot tool exist use appropriate layout and invoke snapshot tool once backup finish
if [[ -x "$SNAPSHOT_TOOL_LOCAL_PATH" ]]; then
  IS_SNAPSHOT=1

  # use snapshot directory layout
  CONTAINER_PATH="$CONTAINER_PATH/$SNAPSHOT_WORK_COPY"

  SNAPSHOT_CMD="$CONTAINER_PATH/$SNAPSHOT_TOOL"
  # kind of `ssh user@server /path/to/container/snapshot.sh`
  [[ ! -z "$BACKUP_SERVER" ]] && SNAPSHOT_CMD="ssh $BACKUP_SERVER $SNAPSHOT_CMD"
fi

[[ ! -z "$BACKUP_SERVER" ]] && BACKUP_TARGET="$BACKUP_SERVER:"
BACKUP_TARGET="${BACKUP_TARGET}${CONTAINER_PATH}/"
BACKUP_SOURCE="$EXEC_PATH/"

EXCLUDE_ARG=""
[[ -f $EXCLUDE_LIST ]] && EXCLUDE_ARG="--exclude-from=$EXCLUDE_LIST --delete-excluded"

echo "Backup:"
[[ ! -z "$DEBUG_ARGS" ]] && echo "  DEBUG: $DEBUG_ARGS"

TARGET_NOTE="$BACKUP_SERVER"
[[ -z "$TARGET_NOTE" ]] && TARGET_NOTE="local"

SNAPSHOT_NOTE=""
[[ $IS_SNAPSHOT -eq 1 ]] && SNAPSHOT_NOTE="(snapshot layout)"

echo "          dir: $BACKUP_SOURCE"                
echo "           to: $TARGET_NOTE"
echo "    container: $CONTAINER_PATH $SNAPSHOT_NOTE"
[[ ! -z "$CUSTOM_ARGS" ]] && echo "  custom args: $CUSTOM_ARGS"

if [[ "$EXCLUDE_ARG" != "" ]]; then
  echo
  echo "<<<< exclude: <<<<"
  cat $EXCLUDE_LIST
  echo ">>>>>>>>>>>>>>>>>>"
fi

if [[ $IS_SNAPSHOT -eq 1 ]]; then
  echo
  echo "NOTE: snapshot layout applied due exising snapshot tool '$SNAPSHOT_TOOL_LOCAL_PATH'"
fi

echo
echo "(press ENTER for continue / Ctrl+C for cancel)"
read

COMMON_ARGS="$DEBUG_ARGS --archive $HARDLINKS $COMPRESS $CUSTOM_ARGS --stats --progress --itemize-changes"

# DEPRECATED: since --mkpath added in rsync 3.2.3 (6 Aug 2020)
MKDIR_P_CMD="mkdir -p $CONTAINER_PATH"
[[ ! -z "$BACKUP_SERVER" ]] && MKDIR_P_CMD="ssh $BACKUP_SERVER $MKDIR_P_CMD"

[[ -z "$DEBUG_ARGS" ]] && $MKDIR_P_CMD
rsync $COMMON_ARGS --recursive --log-file=$LOG_FILE $EXCLUDE_ARG --delete $BACKUP_SOURCE $BACKUP_TARGET
RSYNC_RESULT=$?
[[ $RSYNC_RESULT -eq 0 ]] || die "rsync failed, see errors above"


# Sync logfile
[[ ! -z "$DEBUG_ARGS" ]] && echo "SKIP: $LOG_FILE didn't sync due DEBUG_ARGS=$DEBUG_ARGS" || rsync $COMMON_ARGS $LOG_FILE $BACKUP_TARGET

# Invoke snapshot creation
if [[ $IS_SNAPSHOT -eq 1 ]]; then
  echo "Attempt to create snapshot invoking '$SNAPSHOT_CMD'" | tee -a $LOG_FILE
  [[ ! -z "$DEBUG_ARGS" ]] && echo "SKIP: snapshot didn't invoke due DEBUG_ARGS=$DEBUG_ARGS" || $SNAPSHOT_CMD | tee -a $LOG_FILE
fi

echo
echo "Done! (press ENTER to exit)"
read
