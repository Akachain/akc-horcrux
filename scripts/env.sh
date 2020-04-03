# Setup storage provisioner

PROVISIONER=aws
BUCKET=velero-akc
REGION=ap-southeast-1

# Setup backup
BACKUP_NAME=sonchain-backup
BACKUP_NAMESPACE=sonakachain,sonkafka,sonorderer,sonchain
SCHEDULE_TIME="0 0 * * *"