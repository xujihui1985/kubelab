#!/bin/bash

declare -r KUBELAB_ROOT="$(dirname ${BASH_SOURCE})/.."

rm -rf $KUBELAB_ROOT/cert/{*.json,*.pem,*.csr}