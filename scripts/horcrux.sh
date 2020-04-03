#!/bin/bash
# set -xe

# Setup environment variables
source $(dirname "$0")/env.sh
source $(dirname "$0")/menu.sh
source $(dirname "$0")/func.sh

# Main
COMMAND=$1

if [ "$COMMAND" == "install" ]; then
    install
elif [ "$COMMAND" == "backup" ]; then
    backup
elif [ "$COMMAND" == "start-schedule-backup" ]; then
    startScheduleBackup
elif [ "$COMMAND" == "stop-schedule-backup" ]; then
    stopScheduleBackup $2
elif [ "$COMMAND" == "restore" ]; then
    restore $2
elif [ "$COMMAND" == "get-backups" ]; then
    getBackups
elif [ "$COMMAND" == "get-restores" ]; then
    getRestores
elif [ "$COMMAND" == "del-backup" ]; then
    delBackup $2
elif [ "$COMMAND" == "del-restore" ]; then
    delRestore $2
elif [ "$COMMAND" == "uninstall" ]; then
    uninstall
else
  printHelp
  exit 1
fi