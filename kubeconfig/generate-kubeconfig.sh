#!/bin/bash

declare -r KUBELAB_ROOT="$(dirname ${BASH_SOURCE})/.."
declare -r KUBELAB_CERT="$KUBELAB_ROOT/cert"
declare -r KUBE_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubelab \
	  --region $(gcloud config get-value compute/region) \
	  --format 'value(address)')

kubelab::provision::kubeconfig::worker() {
  for instance in worker-{0,1,2};do
	echo "set-cluster"
	kubectl config set-cluster kubelab \
	  --certificate-authority=$KUBELAB_CERT/ca.pem \
	  --embed-certs=true \
	  --server=https://${KUBE_PUBLIC_ADDRESS}:6443 \
	  --kubeconfig=${instance}.kubeconfig

	echo "set-credentials"
	kubectl config set-credentials system:node:${instance} \
	  --client-certificate=$KUBELAB_CERT/${instance}.pem \
	  --client-key=$KUBELAB_CERT/${instance}-key.pem \
	  --embed-certs=true \
	  --kubeconfig=${instance}.kubeconfig 

	echo "set-context"
	kubectl config set-context default \
	  --cluster=kubelab \
	  --user=system:node:${instance} \
	  --kubeconfig=${instance}.kubeconfig

	echo "use-context"
	kubectl config use-context default --kubeconfig=${instance}.kubeconfig
  done
}

kubelab::provision::kubeconfig::proxy() {
  kubectl config set-cluster kubelab \
	--certificate-authority=$KUBELAB_CERT/ca.pem \
	--embed-certs=true \
	--server=https://${KUBE_PUBLIC_ADDRESS}:6443 \
	--kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
	--client-certificate=$KUBELAB_CERT/kube-proxy.pem \
	--client-key=$KUBELAB_CERT/kube-proxy-key.pem \
	--embed-certs=true \
	--kubeconfig=kube-proxy.kubeconfig 

  kubectl config set-context default \
	--cluster=kubelab \
	--user=system:kube-proxy \
	--kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}

kubelab::provision::kubeconfig::cm() {
  kubectl config set-cluster kubelab \
	--certificate-authority=$KUBELAB_CERT/ca.pem \
	--embed-certs=true \
	--server=https://127.0.0.1:6443 \
	--kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
	--client-certificate=$KUBELAB_CERT/kube-controller-manager.pem \
	--client-key=$KUBELAB_CERT/kube-controller-manager-key.pem \
	--embed-certs=true \
	--kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
	--cluster=kubelab \
	--user=system:kube-controller-manager \
	--kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}

kubelab::provision::kubeconfig::scheduler() {
  kubectl config set-cluster kubelab \
	--certificate-authority=$KUBELAB_CERT/ca.pem \
	--embed-certs=true \
	--server=https://127.0.0.1:6443 \
	--kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
	--client-certificate=$KUBELAB_CERT/kube-scheduler.pem \
	--client-key=$KUBELAB_CERT/kube-scheduler-key.pem \
	--embed-certs=true \
	--kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
	--cluster=kubelab \
	--user=system:kube-scheduler \
	--kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
}

kubelab::provision::kubeconfig::admin() {
  kubectl config set-cluster kubelab \
	--certificate-authority=$KUBELAB_CERT/ca.pem \
	--embed-certs=true \
	--server=https://127.0.0.1:6443 \
	--kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
	--client-certificate=$KUBELAB_CERT/admin.pem \
	--client-key=$KUBELAB_CERT/admin-key.pem \
	--embed-certs=true \
	--kubeconfig=admin.kubeconfig

  kubectl config set-context default \
	--cluster=kubelab \
	--user=admin \
	--kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
}


kubelab::provision::kubeconfig::worker
kubelab::provision::kubeconfig::proxy
kubelab::provision::kubeconfig::cm
kubelab::provision::kubeconfig::scheduler
kubelab::provision::kubeconfig::admin