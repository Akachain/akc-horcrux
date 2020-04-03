# Print features
function printHelp(){
  echo "Usage: "
  echo "  horcrux.sh [command]"
  echo ""
  echo "Available Commands:"
  echo "  install                                 - Setup environment"
  echo "  backup                                  - Create a backup"
  echo "  start-schedule-backup                   - Create a schedule backup"
  echo "  stop-schedule-backup [schedule_name]    - Remove a schedule backup"
  echo "  restore                                 - Create a restore"
  echo "  get-backups                             - Get backups"
  echo "  get-restores                            - Get restores"
  echo "  del-backup [backup_name]                - Delete a backup"
  echo "  del-restore [restore_name]              - Delete a restore"
  echo "  uninstall                               - Uninstall horcrux"
  echo ""
  echo "Use 'horcrux.sh [command] --help' for more information about a command."
}