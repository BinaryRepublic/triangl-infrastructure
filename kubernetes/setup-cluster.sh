#!/usr/bin/env bash

echo "If you are using cloudflare make sure to select the SSL plan 'flexible' during setup"
read -p "Press enter to continue"

kubectl apply -f serviceaccounts/tiller.yml
kubectl apply -f clusterrolebindings/tiller.yml

helm init --service-account tiller

sleep 20

helm repo update

helm install --name cert-manager --version v0.5.2 --namespace kube-system stable/cert-manager

kubectl apply -f clusterissuers/letsencrypt-staging.yml

helm install stable/nginx-ingress --name nginx-ingress --set rbac.create=true

LOAD_BALANCER_IP=
while [ -z "$LOAD_BALANCER_IP" ]; do
    LOAD_BALANCER_IP=$(kubectl get service nginx-ingress-controller -o=custom-columns=:.status.loadBalancer.ingress[*].ip)
    sleep 15
    echo "Waiting for load balancer..."
done

echo "Load balancer IP is $LOAD_BALANCER_IP"

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