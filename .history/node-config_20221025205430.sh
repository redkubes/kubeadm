#!/usr/bin/env bash



###############################################################

# Join worker nodes
kubeadm join 192.168.200.22:6443 --token ea0a83.v55avablmmp8al9q \
	--discovery-token-ca-cert-hash sha256:b90dfa6605b9e9542c329f25d8afccb96ac9fd740941e2ccff556e204c2e86b3

