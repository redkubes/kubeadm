#!/usr/bin/env bash

sudo apt update

## install kubelet, kubeadm and kubectl

sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

## install required packages
# 1.23.8-00

sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet= kubeadm kubectl

## turn off SWAP
sudo vi /etc/fstab
# uncomment:
#/swap.img	none	swap	sw	0	0

sudo swapoff -a
sudo mount -a
free -h

## Enable kernel modules and configure sysctl

# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system

## Installing Docker CE runtime

# Add repo and Install packages
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli

# Create required directories
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create daemon json config file
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker

## Install cri-dockerd as Docker Engine shim for Kubernetes

sudo apt update
sudo apt install git wget curl

VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
echo $VER
wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz
tar xvf cri-dockerd-${VER}.amd64.tgz

# Move cri-dockerd binary package to /usr/local/bin directory
sudo mv cri-dockerd/cri-dockerd /usr/local/bin/

# Validate successful installation by running the commands below:
cri-dockerd --version
# cri-dockerd 0.2.5 (10797dc)

# Configure systemd units for cri-dockerd
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

# Start and enable the services
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket

################## Masters Only #########################

## Initialize master node
# Login to the server to be used as master and make sure that the br_netfilter module is loaded:
lsmod | grep br_netfilter

# Enable kubelet service.
sudo systemctl enable kubelet

# Pull container images
sudo kubeadm config images pull --cri-socket unix:///run/cri-dockerd.sock

# First master only
sudo kubeadm init \
  --pod-network-cidr=10.0.0.0/16 \
  --cri-socket unix:///run/containerd/containerd.sock

# Join additional masters
sudo kubeadm join 192.168.200.22:6443 --token ciq2gc.0ldewso3apzjac6e \
	--discovery-token-ca-cert-hash sha256:38a5d65f8ac322281f6dc546d89ba048bc0946845261e3762db280bb1b4a39a2 \
    --cri-socket unix:///run/cri-dockerd.sock \
    --control-plane


###############################################################

# Join worker nodes
sudo kubeadm join 192.168.200.22:6443 --token ciq2gc.0ldewso3apzjac6e \
	--discovery-token-ca-cert-hash sha256:38a5d65f8ac322281f6dc546d89ba048bc0946845261e3762db280bb1b4a39a2 \
     --cri-socket unix:///run/cri-dockerd.sock

# In PRD we would like to have 3 master nodes. For this we can create Load balancer in the VDC and configure DNAT to the LB. The public IP will have an A-record to point to the external IP
# In this case, the first master (and other 2) need additional configuration:

sudo vim /etc/hosts
# add <internal-lb-ip> api-dev-vancis.redkubes.io

sudo kubeadm init \
  --pod-network-cidr=10.0.0.0/16 \
  --cri-socket unix:///run/containerd/containerd.sock \
  --upload-certs \
  --control-plane-endpoint=api-dev-vancis.redkubes.io

