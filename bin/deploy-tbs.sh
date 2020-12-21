#!/usr/bin/env bash
set -e

shared_services_cluster=${1}

tbs_version="1.0.3"
dependency_version="100.0.46"
dependency_minusone="100.0.22"

repository=$(yq r $PARAMS_YAML tbs.harborRepository)
registry_user=$(yq r $PARAMS_YAML tbs.harborUser)
registry_password=$(yq r $PARAMS_YAML tbs.harborPassword)

download_dir="${TMPDIR}/tbs"
mkdir ${download_dir}
pivnet download-product-files --product-slug='build-service' --release-version="${tbs_version}" --product-file-id=817468 -d ${download_dir}
pivnet download-product-files --product-slug='tbs-dependencies' --release-version="${dependency_minusone}" --product-file-id=801577 -d ${download_dir}
pivnet download-product-files --product-slug='tbs-dependencies' --release-version="${dependency_version}" --product-file-id=834456 -d ${download_dir}

tar -xvf ${download_dir}/build-service-${tbs_version}.tar -C ${download_dir}
kbld relocate -f ${download_dir}/images.lock -f ${download_dir}/images-relocated.lock --repository ${repository}

previous_context=$(kubectl config current-context)
kubectl config use-context "${shared_services_cluster}-admin@${shared_services_cluster}"
ytt ${download_dir}/values.yaml \
    ${download_dir}/manifests/ \
    -v docker_repository=${repository} \
    -v docker_username=${registry_user} \
    -v docker_password=${registry_password} \
    | kbld -f ${download_dir}/images-relocated.lock -f - \
    | kapp deploy -n tanzu-kapp -a tanzu-build-service -f - -y
kp import -f ${download_dir}/descriptor-${dependency_minusone}.yaml
kp import -f ${download_dir}/descriptor-${dependency_version}.yaml

kp clusterstack create demo-stack  \
  --build-image ${repository}/build@sha256:ee37e655a4f39e2e6ffa123306db0221386032d3e6e51aac809823125b0a400e \
  --run-image ${repository}/run@sha256:51cebe0dd77a1b09934c4ce407fb07e3fc6f863da99cdd227123d7bfc7411efa

kp clusterbuilder create demo-cluster-builder \
  --tag ${repository}/demo-cluster-builder \
  --order tbs/demo-cluster-builder-order.yaml \
  --stack demo-stack \
  --store default

kubectl config use-context ${previous_context}

