#!/usr/bin/env bash

kubeadm join LOAD_BALANCER_DNS:LOAD_BALANCER_PORT --token xxx \
	--discovery-token-ca-cert-hash sha256:c9e5f24d987f20b7b8651df5ada121e32a085c05f77af6a129c4fa65393a1c41