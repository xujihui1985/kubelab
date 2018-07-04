#!/bin/bash

declare -r KUBELAB_ROOT="$(dirname ${BASH_SOURCE})/.."
declare -r KUBELAB_CERT="$KUBELAB_ROOT/cert"
declare -r KUBELAB_CONFIG="$KUBELAB_ROOT/kubeconfig"
declare -r KUBELAB_SECRET="$KUBELAB_ROOT/secret"
declare -r KUBELAB_ETCD="$KUBELAB_ROOT/etcd"
declare -r KUBELAB_CONTROLLER="$KUBELAB_ROOT/controller"
declare -r KUBELAB_APILB="$KUBELAB_ROOT/api-loadbalancer"
declare -r KUBELAB_WORKER="$KUBELAB_ROOT/worker"

for instance in worker-{0,1,2}; do
  gcloud compute scp $KUBELAB_CERT/ca.pem $KUBELAB_CERT/${instance}-key.pem $KUBELAB_CERT/${instance}.pem \
	$KUBELAB_CONFIG/${instance}.kubeconfig $KUBELAB_CONFIG/kube-proxy.kubeconfig $KUBELAB_WORKER/config-worker.sh ${instance}:~/
done

for instance in controller-{0,1,2}; do
  gcloud compute scp $KUBELAB_CERT/ca.pem $KUBELAB_CERT/ca-key.pem $KUBELAB_CERT/kubernetes-key.pem $KUBELAB_CERT/kubernetes.pem \
	$KUBELAB_CERT/service-account-key.pem $KUBELAB_CERT/service-account.pem $KUBELAB_CONFIG/admin.kubeconfig \
	$KUBELAB_CONFIG/kube-controller-manager.kubeconfig $KUBELAB_CONFIG/kube-scheduler.kubeconfig $KUBELAB_SECRET/encryption-config.yaml\
	$KUBELAB_ETCD/etcdservice.sh $KUBELAB_CONTROLLER/controller-manager.sh $KUBELAB_APILB/kubernetes.default.svc.cluster.local ${instance}:~/
done
