#!/bin/bash

declare -r KUBELAB_ROOT="$(dirname ${BASH_SOURCE})/.."

source $KUBELAB_ROOT/cert/generate-ca.sh
source $KUBELAB_ROOT/cert/generate-admin.sh
source $KUBELAB_ROOT/cert/generate-worker.sh
source $KUBELAB_ROOT/cert/generate-controller.sh
source $KUBELAB_ROOT/cert/generate-proxy.sh
source $KUBELAB_ROOT/cert/generate-schedule.sh
source $KUBELAB_ROOT/cert/generate-api.sh
source $KUBELAB_ROOT/cert/generate-sa.sh

echo ">> genreate ca"
kubelab::provision::cert::ca
echo ">> genreate admin"
kubelab::provision::cert::admin
echo ">> genreate worker"
kubelab::provision::cert::workers
echo ">> genreate controller"
kubelab::provision::cert::controller
echo ">> genreate proxy"
kubelab::provision::cert::proxy
echo ">> genreate schedule"
kubelab::provision::cert::schedule
echo ">> genreate api"
kubelab::provision::cert::api
echo ">> genreate sa"
kubelab::provision::cert::sa

