#!/usr/bin/env bash

kubectl edit configmap -n kube-system kube-proxy

# set the following