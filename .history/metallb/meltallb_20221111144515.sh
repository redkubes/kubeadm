#!/usr/bin/env bash

# First edit the kube-proxy config map

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

# Then install Metallb using this manifest

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

# And then create the IPAddressPool and L2Advertisement

kubectl apply -f metallb.yaml -n metallb-system