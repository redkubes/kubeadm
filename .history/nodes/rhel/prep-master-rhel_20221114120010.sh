#!/usr/bin/env bash
sudo setenforce 0
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux
sudo tee /etc/sysconfig/modules/istio.modules <<EOF
#!/bin/sh
modprobe br_netfilter
modprobe ip_tables
modprobe iptable_mangle
modprobe iptable_nat
modprobe xt_REDIRECT
modprobe xt_conntrack
modprobe xt_owner
modprobe xt_tcpudp
modprobe bridge
modprobe nf_conntrack
modprobe nf_nat
modprobe x_tables
EOF
chmod 755 /etc/sysconfig/modules/foo.modules
# sudo firewall-cmd --permanent --add-port=6443/tcp
# sudo firewall-cmd --permanent --add-port=2379-2380/tcp
# sudo firewall-cmd --permanent --add-port=10250/tcp
# sudo firewall-cmd --permanent --add-port=10251/tcp
# sudo firewall-cmd --permanent --add-port=10259/tcp
# sudo firewall-cmd --permanent --add-port=10257/tcp
# sudo firewall-cmd --permanent --add-port=179/tcp
# sudo firewall-cmd --permanent --add-port=4789/udp
# sudo firewall-cmd --permanent --add-port=9443/tcp
# # storageos
# sudo firewall-cmd --permanent --add-port=5701/tcp
# sudo firewall-cmd --permanent --add-port=5703/tcp
# sudo firewall-cmd --permanent --add-port=5704/tcp
# sudo firewall-cmd --permanent --add-port=5705/tcp
# sudo firewall-cmd --permanent --add-port=5710/tcp
# sudo firewall-cmd --permanent --add-port=5711/tcp
# sudo firewall-cmd --permanent --add-port=25705-25960/tcp
# sudo firewall-cmd --reload
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io --allowerasing
sudo systemctl start docker
sudo systemctl enable docker
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
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo yum -y install git wget curl
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz
tar xvf cri-dockerd-${VER}.amd64.tgz
sudo mv cri-dockerd/cri-dockerd /usr/local/bin/
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum -y install kubelet-1.23.8-0 kubeadm-1.23.8-0 kubectl-1.23.8-0
sudo systemctl enable kubelet
sudo systemctl start kubelet

