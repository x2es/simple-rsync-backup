#!/bin/bash

#
# https://github.com/x2es/simple-rsync-backup
# v1.3.0
#

WORK_COPY="recent"
LOG_FILENAME="backup.log"

TIMESTAMP_CMD="date +%Y%m%d-%H%M%S"

function die() {
  echo "FATAL ERROR: ${@}"
  exit 1
}

EXEC_PATH="$(dirname $(realpath -s $0))"
SNAPSHOTS_CONTAINER_PATH="$(dirname $EXEC_PATH)"
TARGET_DIR="$(basename $EXEC_PATH)"

[[ "$TARGET_DIR" == "$WORK_COPY" ]] || die "'$EXEC_PATH' is not valid snapshot work copy (expected '$EXEC_PATH/$WORK_COPY')"

LOG_PATH="$EXEC_PATH/$LOG_FILENAME"
TIMESTAMP="$(${TIMESTAMP_CMD})"

WORK_COPY_PATH="$SNAPSHOTS_CONTAINER_PATH/$WORK_COPY"
SNAPSHOT_PATH="$SNAPSHOTS_CONTAINER_PATH/$TIMESTAMP"

echo "Creating snapshot $SNAPSHOT_PATH ..."         | tee -a $LOG_PATH
cp -al $WORK_COPY_PATH $SNAPSHOT_PATH         2>&1  | tee -a $LOG_PATH
echo "Done snapshot $SNAPSHOT_PATH"                 | tee -a $LOG_PATH

