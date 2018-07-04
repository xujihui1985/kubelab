#!/bin/bash


kubelab::provision::cert::ca() {
  cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
	  "expiry": "8760h"
    },
	"profiles": {
	  "kubernetes": {
	    "usages": ["signing", "key enciphermeng", "server auth", "client auth"],
		"expiry": "8760h"
	  }
    }
  }
}
EOF

  cat > ca-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [
    {
	  "C": "CN",
	  "L": "Shanghai",
	  "O": "kubernetes",
	  "OU": "kubelab",
	  "ST": "Shanghai"
	}
  ]
}
EOF

  cfssl gencert -initca ca-csr.json | cfssljson -bare ca

  cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
	  "expiry": "8760h"
    },
	"profiles": {
	  "kubernetes": {
	    "usages": ["signing", "key enciphermeng", "server auth", "client auth"],
		"expiry": "8760h"
	  }
    }
  }
}
EOF

  cat > ca-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [
    {
	  "C": "CN",
	  "L": "Shanghai",
	  "O": "kubernetes",
	  "OU": "kubelab",
	  "ST": "Shanghai"
	}
  ]
}
EOF

  cfssl gencert -initca ca-csr.json | cfssljson -bare ca
}

