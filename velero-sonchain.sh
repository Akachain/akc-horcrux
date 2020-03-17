export BACKUP_NAME=sonchain-backup
export BACKUP_NAMESPACE=sonakachain,sonkafka,sonorderer,sonchain

# Backup

velero backup create $BACKUP_NAME --include-namespaces $BACKUP_NAMESPACE

velero backup describe $BACKUP_NAME
velero backup logs $BACKUP_NAME


# Restore

velero restore create --from-backup $BACKUP_NAME

velero restore describe $BACKUP_NAME
velero restore logs $BACKUP_NAME

# Schedule Backup - on every midnight
velero create schedule schedule-$BACKUP_NAME --schedule="0 0 * * *" --include-namespaces $BACKUP_NAMESPACE