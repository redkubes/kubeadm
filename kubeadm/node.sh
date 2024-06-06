#!/usr/bin/env bash

sudo kubeadm join <master-node>:8443 \
  --token <token> \
  --cri-socket=unix:///var/run/cri-dockerd.sock \
  --discovery-token-ca-cert-hash sha256:<sha>


kubectl label node <node-name> node-role.kubernetes.io/worker=worker
