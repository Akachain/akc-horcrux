function checkVelero {
    local VERSION=$(velero version | grep Version)
    if [ "${VERSION}" != "" ]; then
        return 1
    else
        return 0
    fi
    return 0
}

function install {
    checkVelero
    local IS_INSTALLED=$?

    if [ $IS_INSTALLED == 0 ]; then
      wget https://github.com/vmware-tanzu/velero/releases/download/v1.3.1/velero-v1.3.1-linux-amd64.tar.gz \
      && tar -xvf velero-v1.3.1-linux-amd64.tar.gz \
      && rm velero-v1.3.1-linux-amd64.tar.gz \
      && cd velero-v1.3.1-linux-amd64 \
      && sudo mv velero /usr/local/bin \
      && velero install \
        --provider $PROVISIONER \
        --plugins velero/velero-plugin-for-aws:v1.0.1 \
        --bucket $BUCKET \
        --backup-location-config region=$REGION \
        --snapshot-location-config region=$REGION \
        --secret-file ~/.aws/credentials

      echo 'alias v=velero' >> ~/.zshrc
      echo 'complete -F __start_velero v' >> ~/.zshrc
      echo 'source <(velero completion zsh)' >> ~/.zshrc
      source ~/.zshrc

      install
    else
        echo "Horcrux is installed."
    fi

    return 0
}

function backup {
    velero backup create $BACKUP_NAME --include-namespaces $BACKUP_NAMESPACE
    return 0
}

function startScheduleBackup {
    velero create schedule $BACKUP_NAME --schedule="0 0 * * *" --include-namespaces $BACKUP_NAMESPACE
    return 0
}

function restore {
    velero restore create --from-backup $1
    return 0
}

function getBackups {
    velero backup get
    return 0
}

function getRestores {
    velero backup get
    return 0
}

function delBackup {
    velero delete backup $1
    return 0
}

function delRestore {
    velero delete restore $1
    return 0
}