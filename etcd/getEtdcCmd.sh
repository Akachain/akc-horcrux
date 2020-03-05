
ADVERTISE_URL="https://134.209.178.162:2379"

kubectl exec etcd-node-01 -n kube-system -- sh -c \
"ETCDCTL_API=3 etcdctl \
--endpoints $ADVERTISE_URL \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--key /etc/kubernetes/pki/etcd/server.key \
--cert /etc/kubernetes/pki/etcd/server.crt \
get \"\" --prefix=true -w json" > etcd-kv.json





hfc.setConfigSetting('merchant-connection-profile-path', path.join(__dirname, 'artifacts', 'merchant.yaml'));
hfc.setConfigSetting('cathay-connection-profile-path', path.join(__dirname, 'artifacts', 'cathay.yaml'));