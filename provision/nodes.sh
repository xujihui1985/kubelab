#!/bin/bash

#########################################
# Each worker instance requires a pod subnet allocation from the Kubernetes cluster CIDR range. The pod subnet allocation will be used to configure container 
# networking in a later exercise. The pod-cidr instance metadata will be used to expose pod subnet allocations to compute instances at runtime.
#
# The Kubernetes cluster CIDR range is defined by the Controller Manager's --cluster-cidr flag. 
# In this tutorial the cluster CIDR range will be set to 10.200.0.0/16, which supports 254 subnets.
########################################


# Create three compute instances which will host the kubenetes worker nodes:

echo "create three instance for controller"

for i in 0 1 2; do
  gcloud compute instances create controller-${i} \
	--async \
	--boot-disk-size 200GB \
	--can-ip-forward \
	--preemptible \
	--image-family ubuntu-1804-lts \
	--image-project ubuntu-os-cloud \
	--machine-type n1-standard-1 \
	--private-network-ip 10.240.0.1${i} \
	--scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
	--subnet kubelab-subnet \
	--tags kubelab,controller
done

echo "create three instance for worker"

for i in 0 1 2; do
  gcloud compute instances create worker-${i} \
	--async \
	--boot-disk-size 200GB \
	--can-ip-forward \
	--preemptible \
	--image-family ubuntu-1804-lts \
	--image-project ubuntu-os-cloud \
	--machine-type n1-standard-1 \
	--metadata pod-cidr=10.200.${i}.0/24 \
	--private-network-ip 10.240.0.2${i} \
	--scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
	--subnet kubelab-subnet \
	--tags kubelab,worker
done


echo "verify: "

gcloud compute instances list
