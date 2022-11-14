#!/usr/bin/env bash

helm repo add otomi https://otomi.io/otomi-core
helm repo update

helm install otomi otomi/otomi \
--set cluster.k8sVersion=1.23 \
--set cluster.name=dev \
--set cluster.provider=custom \
--set cluster.domainSuffix: 85.90.91.241.nip.io \
--set otomi.version=main \
--set otomi.adminPassword= bladibla \
--set otomi.globalPullSecret.username=otomi \
--set otomi.globalPullSecret.password: rybdic-juZwi0-myvcaz
cluster:
  k8sVersion: "1.23"
  name: dev
  provider: custom
  domainSuffix: 85.90.91.241.nip.io
otomi:
  version: main
  adminPassword: bladibla
  globalPullSecret:
    username: otomi
    password: rybdic-juZwi0-myvcaz