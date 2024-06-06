#!/usr/bin/env bash
# init master-01
sudo kubeadm init \
  --kubernetes-version=v1.27.7 \
  --pod-network-cidr=10.0.0.0/16 \
  --cri-socket=unix:///var/run/cri-dockerd.sock \
  --upload-certs \
  --control-plane-endpoint=${APISERVER_VIP}:8443

sudo kubeadm join 10.100.25.10:8443 \
  --token 9i7b4y.zwq6h3nmib87tar5 \
	--discovery-token-ca-cert-hash sha256:<> \
	--control-plane \
  --cri-socket=unix:///var/run/cri-dockerd.sock \
  --certificate-key <>