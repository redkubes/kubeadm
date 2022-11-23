#!/usr/bin/env bash

sudo kubeadm join LOAD_BALANCER_DNS:LOAD_BALANCER_PORT --token xxx \
	--discovery-token-ca-cert-hash xxx


## addtionally label the nodes as workers

kubectl label node <worjkernode-name> node-role.kubernetes.io/worker=worker
