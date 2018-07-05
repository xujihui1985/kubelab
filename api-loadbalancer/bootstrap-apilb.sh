#!/bin/bash

kubelab::provision::apilb() {
  local instance=$1 
  gcloud compute ssh $instance \
	--command "sudo apt-get install -y nginx &&
  	sudo mv kubernetes.default.svc.cluster.local \
	 /etc/nginx/sites-available/kubernetes.default.svc.cluster.local &&
	sudo ln -s /etc/nginx/sites-available/kubernetes.default.svc.cluster.local /etc/nginx/sites-enabled/ &&
	sudo systemctl restart nginx"
}


kubelab::provision::apilbs() {
  for instance in controller-{0,1,2}; do
	kubelab::provision::apilb "$instance"
  done
}

kubelab::provision::createlb() {
  echo "get public address"
  local public_address="$(gcloud compute addresses describe kubelab \
    --region $(gcloud config get-value compute/region) \
    --format 'value(address)')"

  echo "create http health check (kubelab-api)"
  gcloud compute http-health-checks create kubelab-api \
	--description "kubelab apiserver health check" \
	--host "kubernetes.default.svc.cluster.local" \
	--request-path "/healthz"

  echo "create firewall rules"
  gcloud compute firewall-rules create kubelab-allow-health-check \
	--network kubelab \
	--source-ranges 209.85.152.0/22,209.85.204.0/22,35.191.0.0/16 \
	--allow tcp

  echo "create target pools kubelab-target-pool"
  gcloud compute target-pools create kubelab-target-pool \
	--http-health-check kubelab-api

  echo "add instance to target pool"
  gcloud compute target-pools add-instances kubelab-target-pool \
	--instances controller-0,controller-1,controller-2

  echo "create forwarding rules"
  gcloud compute forwarding-rules create kubelab-forwarding-rule \
	--address ${public_address} \
	--ports 6443 \
	--region $(gcloud config get-value compute/region) \
	--target-pool kubelab-target-pool
}

kubelab::provision::lb::verify() {
  echo "get public address"
  local kubelab_root="$(dirname ${BASH_SOURCE})/.."
  local kubelab_cert="$kubelab_root/cert"
  local public_address="$(gcloud compute addresses describe kubelab \
    --region $(gcloud config get-value compute/region) \
    --format 'value(address)')"
  echo $public_address
  curl --cacert $kubelab_cert/ca.pem https://${public_address}:6443/version
}

kubelab::provision::apilbs
kubelab::provision::createlb
kubelab::provision::lb::verify
