#!/usr/bin/env bash

helm repo add otomi https://otomi.io/otomi-core
helm repo update

helm install otomi otomi/otomi \
--set cluster.name=dev \
--set cluster.provider=custom \
--set otomi.adminPassword="<your-password>"

