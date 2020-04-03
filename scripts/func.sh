function checkClient {
    local CHECK=$(velero version | grep Client:)
    if [ "${CHECK}" != "" ]; then
        return 1
    else
        return 0
    fi
    return 0
}

function checkServer {
    local CHECK=$(velero version | grep Server:)
    if [ "${CHECK}" != "" ]; then
        return 1
    else
        return 0
    fi
    return 0
}

function installClient {
  checkClient
  local IS_INSTALLED=$?

  if [ $IS_INSTALLED == 0 ]; then
    wget https://github.com/vmware-tanzu/velero/releases/download/v1.3.1/velero-v1.3.1-linux-amd64.tar.gz \
    && tar -xvf velero-v1.3.1-linux-amd64.tar.gz \
    && rm velero-v1.3.1-linux-amd64.tar.gz \
    && cd velero-v1.3.1-linux-amd64 \
    && sudo mv velero /usr/local/bin \

    echo 'alias v=velero' >> ~/.zshrc
    echo 'complete -F __start_velero v' >> ~/.zshrc
    echo 'source <(velero completion zsh)' >> ~/.zshrc
    source ~/.zshrc
  fi

  return 0
}

function installServer {
  checkServer
  local IS_INSTALLED=$?

  if [ $IS_INSTALLED == 0 ]; then
    velero install \
      --provider $PROVISIONER \
      --plugins velero/velero-plugin-for-aws:v1.0.1 \
      --bucket $BUCKET \
      --backup-location-config region=$REGION \
      --snapshot-location-config region=$REGION \
      --secret-file ~/.aws/credentials

    installServer
  else
      echo "Horcrux was installed."
  fi

  return 0
}

function install {
  installClient
  installServer

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

function uninstall {
  kubectl delete namespace/velero clusterrolebinding/velero
  kubectl delete crds -l component=velero

  return 0
}