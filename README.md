# Infrastructure

This repo contains all configuration files for Google Cloud Platform and 
our Kubernetes Cluster.

## Overview

![Image of invoice flow](docs/img/infrastructure.svg)

## 1) Google Cloud Platform Configuration

We are using [terraform](https://www.terraform.io/docs/providers/google)
for configuring all used Google Cloud Services. All configuration files
are located in `/gcp`

> HashiCorp Terraform enables you to safely and predictably create, change, 
and improve infrastructure. It is an open source tool that codifies APIs 
into declarative configuration files that can be shared amongst team members, 
treated as code, edited, reviewed, and versioned. https://www.terraform.io/

Terraform is built on top of Google Cloud API and applies your configuration
files to your Google Cloud Project.

#### Install Terraform

```
Mac OS with Homebrew
$ sudo brew install terraform
```
Or use the official instructions:
https://www.terraform.io/intro/getting-started/install.html

#### Use Terraform

1) `cd /gcp`
2) `terraform init` will install provider binaries to access GCloud API
3) `terraform plan` will show all planned changes
4) `terraform apply` will apply your changes

## 2) Kubernetes

Currently we are running a single production cluster. The `/kubernetes`
directory contains k8s manifests about:
- deployments
- services
- ingresses
- ssl-certificates and letsencrypt-issuer
- cluster-role-bindings (access permissions)

For setting up the cluster [helm](https://docs.helm.sh/) was used as k8s
package manager. Following things were installed using helm:
- nginx ingress-controller
- cert-manager (using letsencrypt)

#### Accessing the cluster

You can access the cluster using [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

```
Mac OS with Homebrew
$ sudo brew install kubernetes-cli

Ubuntu with snap
$ sudo snap install kubectl --classic
```

For authenticating you have to install [Google Cloud SDK](https://cloud.google.com/sdk/docs/).
After installing run: `gcloud init`

Now you can use gcloud-cli to auto-generate your `~/.kube/config` which will be used by kubectl
```
gcloud container clusters get-credentials production --zone europe-west3-a --project triangl-215714
```

Now you can start using: `kubectl`