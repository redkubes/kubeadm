#!/usr/bin/env bash

sudo kubeadm join LOAD_BALANCER_DNS:LOAD_BALANCER_PORT --token xxx \
	--discovery-token-ca-cert-hash xxx


## addtionally 

kubectl label node cb2.4xyz.couchbase.com node-role.kubernetes.io/worker=worker

