#!/usr/bin/env bash

kubectl edit configmap -n kube-system kube-proxy

# set the following:

# apiVersion: kubeproxy.config.k8s.io/v1alpha1
# kind: KubeProxyConfiguration
# mode: "ipvs"
# ipvs:
#   strictARP: true

