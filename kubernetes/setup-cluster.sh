#!/usr/bin/env bash

echo "If you are using cloudflare make sure to select the SSL plan 'flexible' during setup"
read -p "Press enter to continue"

kubectl apply -f serviceaccounts/tiller.yml
kubectl apply -f clusterrolebindings/tiller.yml

helm init --service-account tiller

sleep 15

helm install \
--name cert-manager \
--namespace kube-system \
stable/cert-manager \
--set ingressShim.defaultIssuerName=letsencrypt-prod \
--set ingressShim.defaultIssuerKind=ClusterIssuer

kubectl apply -f clusterissuers/letsencrypt-staging.yml

helm install stable/nginx-ingress --name nginx-ingress --set rbac.create=true

echo "########"
echo "Make sure your DNS records are pointing to the cluster and you are reaching the default-backend using your domain."
read -p "Press enter to deploy a test app using TLS..."

kubectl apply -f setup-cluster-test.yml

echo "########"
echo "https://triangl.io/test available?"
read -p "Press enter to destroy test deployment..."

kubectl delete certificate crt-test
kubectl delete ingress test-ingress
kubectl delete deployment test-deployment
kubectl delete service test-service

echo "########"
echo "Start all services? Make sure all domains of your ingress are pointing to the cluster!"
read -p "Press enter to start-up all applications..."

kubectl apply -f clusterissuers/letsencrypt-prod.yml

kubectl apply -f secrets

# start all services
kubectl apply -f ingress.yml
kubectl apply -f certificates

kubectl apply -f services