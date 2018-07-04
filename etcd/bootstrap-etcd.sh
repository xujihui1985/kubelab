#!/bin/bash

kubelab::provision::etcd() {
  local instance=$1
  gcloud compute ssh $instance \
	--command "wget -q --show-progress --https-only --timestamping \
	https://github.com/coreos/etcd/releases/download/v3.3.5/etcd-v3.3.5-linux-amd64.tar.gz &&
	tar -xvf etcd-v3.3.5-linux-amd64.tar.gz &&
	sudo mv etcd-v3.3.5-linux-amd64/etcd* /usr/local/bin/ &&
	sudo mkdir -p /etc/etcd /var/lib/etcd &&
	sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/ &&
	sudo bash etcdservice.sh &&
	sudo systemctl daemon-reload &&
	sudo systemctl enable etcd &&
	sudo systemctl start etcd"
}

kubelab::provision::etcds() {
  for instance in controller-{0,1,2}; do
	kubelab::provision::etcd "$instance"
  done
}

kubelab::provision::etcds
