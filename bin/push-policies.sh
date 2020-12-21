#!/usr/bin/env bash
set -e

REGISTRY=$(yq r $PARAMS_YAML common.harborDomain)
USER=$(yq r $PARAMS_YAML common.harborUser)
PASSWORD=$(yq r $PARAMS_YAML common.harborPassword)

docker run -v $(pwd)/conftest:/conftest -w /conftest --rm -it ${REGISTRY}/tools/tanzu-application-toolkit:latest \
    bash -c "docker login -u ${USER} -p ${PASSWORD} ${REGISTRY} && conftest push ${REGISTRY}/policy/workload-validation:latest"
