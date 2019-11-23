#!/usr/bin/env bash

PROD_CLUSTER=triangl-prod
#AUTH_CLUSTER=triangl-auth

minikube start -p ${PROD_CLUSTER} --keep-context --cpus 4 --memory 8192
#minikube start -p ${AUTH_CLUSTER} --keep-context

minikube -p ${PROD_CLUSTER} addons enable ingress
#minikube -p ${AUTH_CLUSTER} addons enable ingress

kubectl --context ${PROD_CLUSTER} rollout status deployment/nginx-ingress-controller -n kube-system
#kubectl --context ${AUTH_CLUSTER} rollout status deployment/nginx-ingress-controller -n kube-system

eval "$(minikube -p triangl-prod docker-env)"
