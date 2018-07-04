#!/bin/bash

kubelab::provision::cert::proxy() {
  cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [{
    "C": "CN",
	"L": "Shanghai",
	"O": "system:node-proxier",
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
	kube-proxy-csr.json | cfssljson -bare kube-proxy
}