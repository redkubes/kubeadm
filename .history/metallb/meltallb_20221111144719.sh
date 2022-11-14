#!/usr/bin/env bash

# First edit the kube-proxy config map

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

# Then install Metallb with Helm

helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb

# And then create the IPAddressPool and L2Advertisement

kubectl apply -f metallb.yaml -n metallb-system