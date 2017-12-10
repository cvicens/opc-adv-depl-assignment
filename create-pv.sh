#!/bin/sh

NFS_SERVER=node6.example.com

for i in `seq 1 2`;
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
    path: /exports/pv$i
    server: $NFS_SERVER
    readOnly: false
EOF
oc create -f ./dyn1-pv-create.yaml
done 

for i in `seq 3 4`;
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
    path: /exports/pv$i
    server: $NFS_SERVER
    readOnly: false
EOF
oc create -f ./dyn2-pv-create.yaml
done 
