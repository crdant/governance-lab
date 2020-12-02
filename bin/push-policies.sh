#!/usr/bin/env bash
set -e

REGISTRY=$(yq r $PARAMS_YAML commonSecrets.harborDomain)
pushd conftest/policy 2>&1 > /dev/null
opa build -o ${WORK_DIR}/policy.tar.gz .
popd 2>&1 > /dev/null
oras push --insecure ${REGISTRY}/policy/workload-validation work/policy.tar.gz
