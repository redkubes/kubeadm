#!/usr/bin/env bash

helm uninstall argocd-operator -n argocd
helm uninstall cloudnative-pg -n cnpg-system
helm uninstall gitea-operator -n gitea-operator
helm uninstall ingress-nginx-artifacts -n ingress
helm uninstall ingress-nginx-platform -n ingress
helm uninstall keycloak-artifacts -n keycloak
helm uninstall keycloak-otomi-db -n keycloak
helm uninstall operator-lifecycle-manager -n olm
helm uninstall otomi-operator -n otomi-operator
helm uninstall tekton-dashboard -n tekton-pipelines
helm uninstall tekton-pipelines -n tekton-pipelines


kubectl delete ns argocd
kubectl delete ns cert-manager
kubectl delete ns cnpg-system
kubectl delete ns drone
kubectl delete ns drone-pipelines
kubectl delete ns external-dns
kubectl delete ns external-secrets
kubectl delete ns falco
kubectl delete ns gitea
kubectl delete ns gitea-operator
kubectl delete ns ingress
kubectl delete ns istio-operator
kubectl delete ns istio-system
kubectl delete ns keycloak
kubectl delete ns maintenance
kubectl delete ns monitoring
kubectl delete ns olm
kubectl delete ns opa-exporter
kubectl delete ns opencost
kubectl delete ns operators
kubectl delete ns otomi
kubectl delete ns otomi-operator
kubectl delete ns team-admin
kubectl delete ns tekton-pipelines
kubectl delete ns tekton-pipelines-resolvers

for ns in $(kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}'); do kubectl get ns $ns -ojson | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -; done