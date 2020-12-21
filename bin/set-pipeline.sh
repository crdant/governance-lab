#!/usr/bin/env bash

set -e

shared_services_cluster=${1}

previous_context=$(kubectl config current-context)
kubectl config use-context "${shared_services_cluster}-admin@${shared_services_cluster}"
ytt -f concourse/secrets -f $PARAMS_YAML --ignore-unknown-comments \
    | kapp deploy -n tanzu-kapp -a concourse-secrets -y -f -
kubectl config use-context ${previous_context}

team=$(yq r $PARAMS_YAML common.team)
fly -t ${team} set-pipeline -p petclinic -c concourse/pipeline/petclinic/pipeline.yaml -n
fly -t ${team} unpause-pipeline -p petclinic 

