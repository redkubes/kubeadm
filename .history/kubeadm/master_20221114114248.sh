
#!/usr/bin/env bash

sudo kubeadm init \
  --kubernetes-version=v1.23.8 \
  --pod-network-cidr=10.0.0.0/16 \
  --cri-socket /run/cri-dockerd.sock \
  # --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" \
  # --upload-certs \

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.21/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# additionally install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
export PATH=$PATH:/usr/local/bin