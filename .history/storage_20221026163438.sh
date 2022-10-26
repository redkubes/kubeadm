#!/usr/bin/env bash


## https://github.com/rancher/local-path-provisioner
# Local Path Provisioner provides a way for the Kubernetes users to utilize the local storage in each node. 
# Based on the user configuration, the Local Path Provisioner will create either hostPath or local 
# based persistent volume on the node automatically.

kubectl apply --filename="https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.21/deploy/local-path-storage.yaml"
kubectl patch local-path storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'