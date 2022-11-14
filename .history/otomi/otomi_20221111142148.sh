#!/usr/bin/env bash

helm repo add otomi https://otomi.io/otomi-core
helm repo update


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