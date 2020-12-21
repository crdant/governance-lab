#!/usr/bin/env bash
set -e

shared_services_cluster=${1}

namespace="sonarqube"
postgres_user="sonarqube"
postgres_db="sonarqube"
postgress_password="$(yq r ${PARAMS_YAML} sonarqube.databasePassword)"
postgress_adminpw="$(yq r ${PARAMS_YAML} sonarqube.adminPassword)"

function create_namespace() {
    local cluster=$(yq r ${PARAMS_YAML} tmc.shared-services-cluster)
    local workspace=$(yq r ${PARAMS_YAML} tmc.platform-workspace)
    tmc cluster namespace create --name ${namespace} --description "Sonarqube source code scanner" \
        --workspace-name ${workspace} --cluster-name ${cluster} \
        --management-cluster-name attached  --provisioner-name attached
}

function prepare_helm() {
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
}

create_namespace
prepare_helm

previous_context=$(kubectl config current-context)
kubectl config use-context "${shared_services_cluster}-admin@${shared_services_cluster}"

helm install -n ${namespace} sonarqube-db bitnami/postgresql \
    --set postgresUsername=${postgres_user} \
    --set postgresDatabase=${postgress_db} \
    --set postgresPassword=${postgress_password} \
    --set postgresPostgresPassword=${postgres_adminpw}

ytt -f sonarqube -f secrets/lab.yaml --ignore-unknown-comments \
    | kapp deploy -n tanzu-kapp --into-ns ${namespace} -a sonarqube -y -f -

kubectl config use-context ${previous_context}

