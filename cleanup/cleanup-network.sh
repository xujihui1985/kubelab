#!/bin/bash

gcloud -q compute forwarding-rules delete kubelab-forwarding-rule \
      --region $(gcloud config get-value compute/region)

gcloud -q compute target-pools delete kubelab-target-pool

gcloud -q compute http-health-checks delete kubelab-api

gcloud -q compute addresses delete kubelab

gcloud -q compute firewall-rules delete \
  kubelab-allow-internal \
  kubelab-allow-external \
  kubelab-allow-health-check

gcloud -q compute routes delete \
  kubernetes-route-10-200-0-0-24 \
  kubernetes-route-10-200-1-0-24 \
  kubernetes-route-10-200-2-0-24 

gcloud -q compute networks subnets delete kubelab-subnet
gcloud -q compute networks delete kubelab
