#!/bin/bash

kubelab::provision::cert::worker() {
  local instance=$1
  cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
	"size": 2048
  },
  "names": [{
    "C": "US",
	"L": "Shanghai",
	"O": "system:nodes",
	"OU": "kubelab",
	"ST": "Shanghai"
  }]
}
EOF

  EXTERNAL_IP=$(
	gcloud compute instances describe ${instance} \
	  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)'
  )
  INTERNAL_IP=$(
    gcloud compute instances describe ${instance} \
	  --format 'value(networkInterfaces[0].networkIP)'
  )
  cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
	-profile=kubernetes \
	${instance}-csr.json | cfssljson -bare ${instance}
}

kubelab::provision::cert::workers() {
  for instance in worker-{0,1,2}; do
    kubelab::provision::cert::worker $instance  
  done
}
