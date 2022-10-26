#!/usr/bin/env bash

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



###############################################################

# Join worker nodes
kubeadm join 192.168.200.22:6443 --token ea0a83.v55avablmmp8al9q \
	--discovery-token-ca-cert-hash sha256:b90dfa6605b9e9542c329f25d8afccb96ac9fd740941e2ccff556e204c2e86b3

