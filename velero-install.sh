# INSTALL CLIENT

wget https://github.com/vmware-tanzu/velero/releases/download/v1.3.1/velero-v1.3.1-linux-amd64.tar.gz \
&& tar -xvf velero-v1.3.1-linux-amd64.tar.gz \
&& rm velero-v1.3.1-linux-amd64.tar.gz \
&& cd velero-v1.3.1-linux-amd64 \
&& sudo mv velero /usr/local/bin

echo 'alias v=velero' >> ~/.zshrc
echo 'complete -F __start_velero v' >> ~/.zshrc
echo 'source <(velero completion zsh)' >> ~/.zshrc

source ~/.zshrc


# INSTALL SERVER

export PROVISIONER=aws
export BUCKET=velero-akc
export REGION=ap-southeast-1

velero install \
    --provider $PROVISIONER \
    --plugins velero/velero-plugin-for-aws:v1.0.1 \
    --bucket $BUCKET \
    --backup-location-config region=$REGION \
    --snapshot-location-config region=$REGION \
    --secret-file ~/.aws/credentials

# See backup location
k describe backupstoragelocations -n velero
k describe volumesnapshotlocations -n velero

# Backup
export BACKUP_NAME=testnet

velero backup create $BACKUP_NAME

velero backup describe $BACKUP_NAME  --details

# Restore
export BACKUP_NAME=testnet

velero restore create --from-backup $BACKUP_NAME

velero restore describe $BACKUP_NAME --details