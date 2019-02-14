#!/usr/bin/env bash

echo "If you are using cloudflare make sure to select the SSL plan 'flexible' during setup"
read -p "Press enter to continue"

kubectl apply -f serviceaccounts/tiller.yml
kubectl apply -f clusterrolebindings/tiller.yml

helm init --service-account tiller

sleep 15

# Install the CustomResourceDefinition resources separately
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Label the cert-manager namespace to disable resource validation
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install \
--name cert-manager \
--namespace cert-manager \
--version v0.6 \
stable/cert-manager \
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

kubectl delete clusterissuer letsencrypt-staging
kubectl apply -f clusterissuers/letsencrypt-prod.yml

kubectl apply -f secrets

# start all services
kubectl apply -f ingress.yml
kubectl apply -f certificates

kubectl apply -f services