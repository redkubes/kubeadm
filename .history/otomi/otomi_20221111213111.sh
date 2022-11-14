#!/usr/bin/env bash

helm repo add otomi https://otomi.io/otomi-core
helm repo update

helm install otomi otomi/otomi \
--set cluster.k8sVersion=1.23 \
--set cluster.name=dev \
--set cluster.provider=custom \
--set cluster.domainSuffix=85.90.91.241.nip.io \
--set otomi.version=main \
--set otomi.adminPassword=bladibla \
--set otomi.globalPullSecret.username=otomi \
--set otomi.globalPullSecret.password=rybdic-juZwi0-myvcaz


helm repo add ondat https://ondat.github.io/charts && \
helm repo update && \
kubectl apply --filename="https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.21/deploy/local-path-storage.yaml" && \
helm install ondat ondat/ondat \
  --namespace=storageos \
  --create-namespace \
  --set ondat-operator.cluster.portalManager.enabled=true \
  --set ondat-operator.cluster.portalManager.clientId=397876e3-9861-401f-af63-5797eaaf5d61 \
  --set ondat-operator.cluster.portalManager.secret=be9bee5e-b468-4cc5-9952-592abb4adf4a \
  --set ondat-operator.cluster.portalManager.apiUrl=https://portal-setup-7dy4neexbq-ew.a.run.app \
  --set ondat-operator.cluster.portalManager.tenantId=ca4c9a07-62f0-42e0-8e56-25bcf7d76a93 \
  --set etcd-cluster-operator.cluster.replicas=3 \
  --set etcd-cluster-operator.cluster.storage=6Gi \
  --set etcd-cluster-operator.cluster.resources.requests.cpu=100m \
  --set etcd-cluster-operator.cluster.resources.requests.memory=300Mi \
  --set etcd-cluster-operator.cluster.storageclass="local-path"