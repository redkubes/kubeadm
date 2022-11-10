#!/usr/bin/env bash

# First edit the kube-proxy config map

kubectl edit configmap -n kube-system kube-proxy

# set the following:

# apiVersion: kubeproxy.config.k8s.io/v1alpha1
# kind: KubeProxyConfiguration
# mode: "ipvs"
# ipvs:
#   strictARP: true

# Then install Metallbwith manifest

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

# create the IPAddressPool and L2Advertisement

kubectl apply -f metallb.yaml -n metallb-system