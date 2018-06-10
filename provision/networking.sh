#!/bin/bash

VPC="kubelab"

echo "create a vpc"
gcloud compute networks create $VPC --subnet-mode custom

gcloud compute networks subnets create kubelab-subnet \
 --network $VPC \
 --range 10.240.0.0/24


# Create a firewall rule that allows internal communication across all protocols:
echo "Create a firewall rule that allows internal communication across all protocols"
gcloud compute firewall-rules create kubelab-allow-internal \
  --allow tcp,udp,icmp \
  --network $VPC \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

# Create a firewall rule that allows external SSH, ICMP, and HTTPS:
echo "Create a firewall rule that allows external SSH, ICMP, and HTTPS"
gcloud compute firewall-rules create kubelab-allow-external \
  --allow tcp:22,tcp:6443,icmp \
  --network $VPC \
  --source-ranges 0.0.0.0/0

# list the firewall rules
echo "list firewall rules"
gcloud compute firewall-rules list --filter="network:$VPC"


# Allocate a static IP address that will be attached to the external load balancer fronting the Kubernetes API Servers:
echo "Allocate a static IP address that will be attached to the external load balancer fronting the Kubernetes API Servers"
REGION=$(gcloud config get-value compute/region)
gcloud compute addresses create $VPC \
  --region $REGION

# verify the kubelab static ip address
echo "verify kubelab static ip address"
gcloud compute addresses list --filter="name=('$VPC')"
