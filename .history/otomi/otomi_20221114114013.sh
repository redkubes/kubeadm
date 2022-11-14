#!/usr/bin/env bash

helm repo add otomi https://otomi.io/otomi-core
helm repo update

helm install otomi otomi/otomi \
--set cluster.k8sVersion=1.23 \
--set cluster.name=dev \
--set cluster.provider=custom \
--set cluster.domainSuffix=<public-ip>.nip.io \
--set otomi.adminPassword=fillinnpasswordhere \

