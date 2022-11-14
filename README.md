# Introduction
This repo contains instructions and code to setup a K8s cluster using Kubeadm on Debian and RHEL based systems. In the script you can set the required K8s version.

# Procedure

1. Prepare Linux machines
2. Create K8s cluster using Kubeadm and install prerequisites
3. Install Otomi

# Project structure
```
.
├── nodes    # Scripts to prepare master and worker nodes
    |__debian
    |__rhel
├── k8s   # Script to create K8s cluster and install Calico, Metallb and Local-path provisioner. Script to add worker nodes to the cluster
|__ otomi    # Script to install Otomi

