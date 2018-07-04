#!/bin/bash

kubelab::provision::cert::sa() {
  cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [{
    "C": "US",
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
	-profile=kubernetes \
	service-account-csr.json | cfssljson -bare service-account
}