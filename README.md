

<img src="./horcrux-icon-text.png" alt="drawing" height="120"/>
<h1>Disaster Recovery Tool for Hyperledger Fabric on Kubernetes</h1>

<h2>I. Introdution</h2>

Akc-Horcrux is designed to backup and restore a Hyperledger Fabric network deployed on Kubernetes from potential catastrophic events. Like the dark lord, as long as there is a remaining horcrux, the network cannot die.
To create a Hyperledger Fabric network using Kubernetes, we provide another tool call [AKC-Mamba](https://github.com/Akachain/akc-mamba).

When running a Fabric blockchain network, we often run things in high availability mode. We might run multiple peers node and services, then if a peer dies, the other continues to function properly. Later, because of the Hyperledger Fabric mechanism, the administrator can always remove the faulty peer and create a new one to re-sync data back from other peer nodes.

#### So why does a peer die ?
Unfortunately, a peer is a piece of software in a very complex network of many components. In Hyperledger Fabric, we have a lot of problems of the Kafka-based ordering service. Sometimes, the peer or its state database data is corrupted due to disk faulty or malicious intention. Funny enough, we once had to deal with the case where the master administrator accidentally delete the whole production Kubernetes cluster for **cost-saving** purpose.
After these kinds of event, the peer becomes faulty and just refuses to continue to accept blocks. 

#### Great, we will create new peer and sync back data from the network.
This process consumes **a lot** of time as our ledger can only grow over time. The peer cannot just simply download the ledger from other peer nodes. It must, in fact, verify every block in the ledger from the genesis block until the most recent one. 

To put it simpy, the good old practice of backup is the best way to protect network data. It is also useful for routine administrative purposes such as migrating cluster resources to other cluster, or replicating clusters for development and testing.


<h2>II. What do we need to backup?</h2>

In a Hyperledger Fabric network on Kubernetes, or simply any Kubernetes based solution, we need to backup two things:
- __Configuration, State and Metadata of the cluster:__ resources are defined with a Kubernetes CRD (Custom Resource Definition) stored in etcd.
- __Persistent volumes:__ includes Crypto materials, Channel artifacts, Peer backup files, Orderer backup files to recreate the network.

Obviously, we can't do all of these tasks by ourselves. We rely on a VMWare tool called [velero](https://github.com/vmware-tanzu/velero/) to backup our Kubernetes cluster.

<h2>III. Hoxcrux tool</h2>

_Features:_
<table>
  <tr>
    <td>
      install
    </td>
    <td>
      Setup environment for horcrux tool
    </td>
  </tr>
  <tr>
    <td>
      backup
    </td>
    <td>
      Create a backup, then store to cloud storage as configration in env.sh file
    </td>
  </tr>
  <tr>
    <td>
      start-schedule-backup 
    </td>
    <td>
      Create a schedule backup
    </td>
  </tr>
  <tr>
    <td>
      stop-schedule-backup [schedule_name]
    </td>
    <td>
      Remove a schedule backup
    </td>
  </tr>
  <tr>
    <td>
      restore [backup_name]
    </td>
    <td>
      Create a restore
    </td>
  </tr>
  <tr>
    <td>
      get-backups
    </td>
    <td>
      Get backups
    </td>
  </tr>
  <tr>
    <td>
      get-restores
    </td>
    <td>
      Get restores
    </td>
  </tr>
  <tr>
    <td>
      del-backup [backup_name]
    </td>
    <td>
      Delete a backup
    </td>
  </tr>
  <tr>
    <td>
      del-restore [restore_name]
    </td>
    <td>
      Delete a restore
    </td>
  </tr>
  <tr>
    <td>
      uninstall
    </td>
    <td>
      Uninstall horcrux
    </td>
  </tr>
</table>

<h2>IV. How to use?</h2>

<h3>1. Install</h3>

_Description_

To setup environment for hoxcrux tool and make alias _hoxcrux_ for it.

To install velero client and velero server on K8S cluster.

If you want to change config for _storage provisioner_, you must run uninstall feature before use this.

_Pre-requisites_

- zsh/bash (zsh is prefer for automated completion)
- Configure __storage provisioner__ of AWS in file env.sh
- A credential file for AWS: _~/.aws/credentials_

_Command_

```
$ ./scripts/horcrux.sh install
```

<h3>2. Uninstall</h3>

_Description_

To remove resources of velero server on your K8S cluster

_Command_

```
$ horcrux uninstall
```

<h3>3. Backup</h3>

_Description_

Create a backup request for one or more namespaces, then store it to AWS.

Configuration, State and Metadata of the cluster are stored on S3 service.
Persistent volumes are stored on snapshots service.

_Pre-requisites_

Configure BACKUP_NAME and BACKUP_NAMESPACE in env.sh file.

BACKUP_NAME must be unique.
If BACKUP_NAMESPACE=all, then all namespaces will be backup.

```
BACKUP_NAME=sonchain-backup5
BACKUP_NAMESPACE=sonakachain,sonkafka,sonorderer,sonchain
# BACKUP_NAMESPACE=all
```

_Command_

```
$ horcrux backup
```

Output:

```
Backup request "sonchain-backup5" submitted successfully.
Run `velero backup describe sonchain-backup5` or `velero backup logs sonchain-backup5` for more details.
```

_Check_

Then, using _get-backups_ feature to see your backups

```
$ horcrux get-backups
```

Output:
```
NAME                             STATUS                       CREATED                         EXPIRES   STORAGE LOCATION   SELECTOR
sonchain-backup                  Completed                    2020-03-31 03:31:01 +0000 UTC   21d       default            <none>
sonchain-backup1                 Completed                    2020-04-03 02:57:46 +0000 UTC   24d       default            <none>
sonchain-backup2                 Completed                    2020-04-03 03:46:07 +0000 UTC   24d       default            <none>
sonchain-backup3                 Completed                    2020-04-03 05:28:06 +0000 UTC   25d       default            <none>
sonchain-backup4                 Completed                    2020-04-03 07:32:37 +0000 UTC   25d       default            <none>
sonchain-backup5                 Completed                    2020-04-03 07:40:32 +0000 UTC   25d       default            <none>
```

Using <i>velero backup describe [BACKUP_NAME]</i> to see backup process and more details.

```
$ velero backup describe sonchain-backup5
```

_Delete_

```
$ horcrux del-backup sonchain-backup5
```

<h3>4. Restore</h3>

_Description_

Create a restore request from a BACKUP_NAME.

_Command_

You can use _horcrux get-backups_ to get all BACKUP_NAMEs

```
$ horcrux restore sonchain-backup5
```

_Check_

```
$ horcrux get-restores
```

Output:
```
NAME                              BACKUP             STATUS      WARNINGS   ERRORS   CREATED                         SELECTOR
sonchain-backup2-20200403051836   sonchain-backup2   Completed   0          0        2020-04-03 05:18:37 +0000 UTC   <none>
sonchain-backup3-20200403053751   sonchain-backup3   Completed   0          0        2020-04-03 05:37:52 +0000 UTC   <none>
sonchain-backup5-20200403074443   sonchain-backup5   Completed   0          0        2020-04-03 07:44:44 +0000 UTC   <none>
```

_Delete_

```
$ horcrux del-restore sonchain-backup5-20200403074443
```

<h3>4. Schedule backup</h3>

_Description_

Create schedule backup

_Pre-requisites_

- Configure BACKUP_NAME and BACKUP_NAMESPACE in env.sh file.
- Configure SCHEDULE_TIME. Interval is specified by a [Cron expression](https://en.wikipedia.org/wiki/Cron).

_Command_

```
$ horcrux start-schedule-backup
```

_Check_

Scheduled backups are saved with the name \<SCHEDULE NAME>-\<TIMESTAMP>, where <TIMESTAMP> is formatted as YYYYMMDDhhmmss.

```
$ horcrux get-backups
```

Output:

```
NAME                             STATUS                       CREATED                         EXPIRES   STORAGE LOCATION   SELECTOR
sonchain-backup-20200403062531   Completed                    2020-04-03 06:25:31 +0000 UTC   24d       default            <none>
```

_Stop schedule backup_

Using: horcrux stop-schedule-backup BACKUP_NAME

```
$ horcrux stop-schedule-backup sonchain-backup
```

<h2>V. LICENSE</h2>

Akc-Horcrux project source code files are made available under MIT license, located in the LICENSE file. Basically, you can do whatever you want as long as you include the original copyright and license notice in any copy of the software/source.
