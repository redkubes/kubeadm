#!/usr/bin/env bash



## Worker only

kubeadm join 192.168.200.22:6443 --token 53j5ef.jlbasgyepi12fler \
	--discovery-token-ca-cert-hash sha256:8d0b9f531340911772948f807cba355ca2355b218db7ef196bbe86a1ff4661f1

## Oracle

sudo yum install kubelet-1.23.8-0 kubeadm-1.23.8-0 kubectl-1.23.8-0

sudo kubeadm init \
  --kubernetes-version=v1.23.8 \
  --pod-network-cidr=10.0.0.0/16 \
  --cri-socket /run/cri-dockerd.sock



mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml