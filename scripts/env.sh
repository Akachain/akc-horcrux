# Setup storage provisioner

PROVISIONER=aws
BUCKET=velero-akc
REGION=ap-southeast-1

# Setup backup
BACKUP_NAME=sonchain-backup5
BACKUP_NAMESPACE=sonakachain,sonkafka,sonorderer,sonchain
# BACKUP_NAMESPACE=all
SCHEDULE_TIME="0 0 * * *"