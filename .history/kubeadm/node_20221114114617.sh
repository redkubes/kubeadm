#!/usr/bin/env bash

kubeadm join 192.168.200.22:6443 --token u1y9bd.q9528zqfst3k77a1 \
	--discovery-token-ca-cert-hash sha256:c9e5f24d987f20b7b8651df5ada121e32a085c05f77af6a129c4fa65393a1c41