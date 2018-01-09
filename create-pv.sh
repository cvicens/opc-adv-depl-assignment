#!/bin/sh

NFS_SERVER=node6.example.com
NFS_ROOT_PATH=/srv/nfs/user-vols

for i in `seq 1 50`;
do
cat << EOF > ./dyn1-pv-create.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv$i 
spec:
  capacity:
    storage: 1Gi 
  accessModes:
    - ReadWriteOnce 
  persistentVolumeReclaimPolicy: Recycle
  nfs: 
    path: $NFS_ROOT_PATH/pv$i
    server: $NFS_SERVER
    readOnly: false
EOF
oc create -f ./dyn1-pv-create.yaml
done 

for i in `seq 51 100`;
do
cat << EOF > ./dyn2-pv-create.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv$i 
spec:
  capacity:
    storage: 1Gi 
  accessModes:
    - ReadWriteMany 
  persistentVolumeReclaimPolicy: Retain
  nfs: 
    path: $NFS_ROOT_PATH/pv$i
    server: $NFS_SERVER
    readOnly: false
EOF
oc create -f ./dyn2-pv-create.yaml
done 
