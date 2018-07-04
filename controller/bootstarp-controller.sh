#!/bin/bash

kubelab::provision::controller() {
  local instance=$1
  gcloud compute ssh $instance \
	--command "wget -q --https-only --timestamping \
	https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-apiserver \
	https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-controller-manager \
	https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-scheduler \
	https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubectl &&
	chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl &&
	sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/ &&
	sudo mkdir -p /etc/kubernetes/config &&
	sudo mkdir -p /var/lib/kubernetes/ &&
	sudo mv ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
	  service-account-key.pem service-account.pem \
	  encryption-config.yaml /var/lib/kubernetes/ &&
	sudo mv kube-controller-manager.kubeconfig /var/lib/kubernetes/ &&
	sudo mv kube-scheduler.kubeconfig /var/lib/kubernetes/ &&
	sudo bash controller-manager.sh && 
	sudo systemctl daemon-reload &&
	sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler &&
	sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler"
}

kubelab::provision::controller::rolebinding() {
  gcloud compute ssh controller-0 \
	--command "kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --user=admin &&
	 kubectl create clusterrolebinding admin-cluster-admin-binding --clusterrole=cluster-admin --user=kubelab"
}

kubelab::provision::controllers() {
  for instance in controller-{0,1,2}; do
	kubelab::provision::controller "$instance"
  done
}

kubelab::provision::controllers
kubelab::provision::controller::rolebinding
