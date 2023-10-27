Follow these instructions to upgrade Kubernetes using Kubeadm

## Upgrade master node(s)

1. Find the required {Kubernetes release](https://kubernetes.io/releases/)

Here we are upgrading from 1.24.6 to 1.25.11

2. Check if upgrade to required version is supported:

```
kubeadm upgrade plan v1.25.11
```

3. Install required packages:

```
yum -y install kubeadm-1.25.11-0
```

4. execute a dry run to see what actions would be performed.

```
kubeadm upgrade apply v1.25.11 --dry-run
```

5. execute the kubeadm upgrade

```
kubeadm upgrade apply v1.25.11
```

6. Upgrade kubelet and kubectl

```
yum -y install kubelet-1.25.11-0 kubectl-1.25.11-0
```

7. Restart kubelet

```
sudo systemctl daemon-reload && sudo systemctl restart kubelet
```

## Upgrade worker nodes

1. Install required packages:

```
yum -y install kubeadm-1.25.11-0
```

2. execute the kubeadm upgrade

```
kubeadm upgrade node
```

3. Upgrade kubelet

```
yum -y install kubelet-1.25.11-0
```

4. Restart kubelet service

```
sudo systemctl daemon-reload && sudo systemctl restart kubelet
```

4. Restart containerd service

```
sudo systemctl daemon-reload && sudo systemctl restart containerd
```