#!/bin/bash

for i in 0 1 2; do
  gcloud compute routes create kubernetes-route-10-200-${i}-0-24 \
	--network kubelab \
	--next-hop-address 10.240.0.2${i} \
	--destination-range 10.200.${i}.0/24
done

gcloud compute routes list --filter "network: kubelab"