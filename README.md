# Introduction
This repo contains instructions and code to setup a K8s cluster using Kubeadm on Debian and RHEL based systems.

# Procedure

1. Install Kubeadm and all required packages, create a cluster, add additional master nodes, and worker nodes
2. Install Metallb (requires a manual action!)
3. Install Otomi with Helm

# Project structure
```
.
├── nodes    # Scripts to create master and worker nodes
    |__debian
    |__rhel
├── metallb   # Metallb manifest
|__ otomi    # Values for Otomi Helm chart install

