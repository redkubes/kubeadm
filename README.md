# Introduction
This repo contains instructions and code to setup a K8s cluster using Kubeadm on Debian and RHEL based systems. In the script you can set the required K8s version.

# Procedure

1. Prepare Linux machines
2. Create K8s cluster using Kubeadm and install prerequisites
3. Install Otomi

# Project structure
```
.
├── nodes    # Scripts to prepare master and worker node OS
    ├──debian
       ├──prep-master
       ├──prep-worker
    |__rhel
       ├──prep-master
       ├──prep-worker
├── kubeadm   # Scripts to create K8s cluster and install 
Calico, Metallb and Local-path provisioner and add worker nodes to the cluster.
    ├──master
    ├──node
|__ otomi    # Script to install Otomi
```

# Notes

- Make sure the host names of the master(s) and workers are added to the /etc/hosts file
- After a restart, check if `cri-docker.service` `docker` services are up: `systemctl status cri-docker.socket`
- Make sure to set `setenforce 0` after a reboot
- kubelet will be started when kubeadm init is done

```
sudo setenforce 0
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo systemctl restart kubelet
```