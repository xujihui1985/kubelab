#!/bin/bash


kubelab::provision::cert::admin() {
  cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "name": [{
	"C": "CN",
	"L": "Shanghai",
	"O": "system:masters",
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
  admin-csr.json | cfssljson -bare admin

}
