#!/bin/bash

kubelab::provision::cert::controller() {
  cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [{
    "C": "CN",
	"L": "Shanghai",
	"O": "system:kube-controller-manager",
	"OU": "kubelab",
	"ST": "Shanghai"
  }]
}
EOF
  cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-profile=kubernetes \
	kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
}
