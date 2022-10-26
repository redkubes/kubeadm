# vancis-k8s
This repo contains the instructions and code to setup a K8s cluster using Kubeadm in a Vancis VDC (VMware Cloud director)

Procedure:

1. [Create a VM](create-vm.md)
2. Install OS (now Ubuntu)
3. Install Kubeadm and all required packages
4. Create a new cluster, add an extra master node or add a worker node to a cluster
5. Install Calico
6. Install Metallb
7. Configure firewall for DNAT
8. Install local-path storageclass
9. Install Otomi
