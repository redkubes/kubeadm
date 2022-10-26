#!/usr/bin/env bash


## https://github.com/rancher/local-path-provisioner

kubectl apply --filename="https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.21/deploy/local-path-storage.yaml"

kubectl patch local-path storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'