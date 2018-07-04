#!/bin/bash

kubelab::provision::cert::api() {
  KUBE_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubelab \
	  --region $(gcloud config get-value compute/region) \
	  --format 'value(address)')

  cat > kubernetes-csr.json <<EOF
{
  "CN": "kubelab",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [{
    "C": "CN",
	"L": "Shanghai",
	"O": "kubelab",
	"OU": "kubelab",
	"ST": "Shanghai"
  }]
}
EOF

  cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBE_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
	-profile=kubernetes \
	kubernetes-csr.json | cfssljson -bare kubernetes
}
