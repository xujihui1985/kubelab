#!/bin/bash

kubelab::provision::cert::schedule() {
  cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [{
    "C": "CN",
	"L": "Shanghai",
	"O": "system:kube-scheduler",
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
	kube-scheduler-csr.json | cfssljson -bare kube-scheduler
}