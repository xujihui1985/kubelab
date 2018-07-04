#!/bin/bash

KUBELAB_ROOT="$(dirname ${BASH_SOURCE})/.."
KUBELAB_CERT="$KUBELAB_ROOT/cert"
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubelab \
    --region $(gcloud config get-value compute/region) \
    --format 'value(address)')

kubectl config set-cluster kubelab \
  --certificate-authority=$KUBELAB_CERT/ca.pem \
  --embed-certs=true \
  --server=https://$KUBERNETES_PUBLIC_ADDRESS:6443 \
  --kubeconfig=kubelab.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=$KUBELAB_CERT/admin.pem \
  --client-key=$KUBELAB_CERT/admin-key.pem \
  --kubeconfig=kubelab.kubeconfig

kubectl config set-context kubelab \
  --cluster=kubelab \
  --user=admin \
  --kubeconfig=kubelab.kubeconfig

kubectl config use-context kubelab --kubeconfig=kubelab.kubeconfig