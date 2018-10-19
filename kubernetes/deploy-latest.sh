#!/usr/bin/env bash

DEPLOYMENT=$1
IMAGE=$1

LATEST_TAG="$(gcloud container images list-tags eu.gcr.io/triangl-215714/${IMAGE} | sed '2!d' | awk '{print $2}')"

kubectl apply -f deployments/${DEPLOYMENT}.yml
kubectl set image deployment/${DEPLOYMENT} ${DEPLOYMENT}=eu.gcr.io/triangl-215714/${IMAGE}:${LATEST_TAG}