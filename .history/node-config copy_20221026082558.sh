#!/usr/bin/env bash

sudo apt update

sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

# requirements storageos
sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r)


sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
sudo apt-get install -y kubelet=1.23.8-00 kubectl=1.23.8-00 kubeadm=1.23.8-00

sudo apt-mark hold kubelet kubeadm kubectl


#-------------------------------------------

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# OS="xUbuntu_20.04"
# VERSION="1.23"

# cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
# deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
# EOF
# cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
# deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
# EOF

# curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
# curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

# sudo apt-get update
# sudo apt-get install cri-o cri-o-runc cri-tools -y

# sudo systemctl daemon-reload
# sudo systemctl enable crio --now

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
sudo apt-get install -y kubelet=1.23.8-00 kubectl=1.23.8-00 kubeadm=1.23.8-00

sudo apt-mark hold kubelet kubeadm kubectl

sudo apt-get install -y jq
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF

sudo apt-get update
sudo apt-get install -y linux-modules-extra-$(uname -r)

############## MASTER ONLY ####################################

IPADDR="192.168.200.22"
NODENAME=$(hostname -s)
POD_CIDR="10.0.0.0/16"

sudo kubeadm init --apiserver-advertise-address=$IPADDR  \
  --apiserver-cert-extra-sans=$IPADDR  \
  --pod-network-cidr=$POD_CIDR \
  --node-name $NODENAME

###############################################################

# Join worker nodes
sudo kubeadm join 192.168.200.22:6443 --token ea0a83.v55avablmmp8al9q \
	--discovery-token-ca-cert-hash sha256:b90dfa6605b9e9542c329f25d8afccb96ac9fd740941e2ccff556e204c2e86b3

