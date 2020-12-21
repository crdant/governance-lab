#!/usr/bin/env bash

TEAM=${1} # (yq r ${PARAMS_YAML} common.team)
PLATFORM_WORKSPACE=${2} # $(yq r ${PARAMS_YAML} tmc.platform-workspace)
WORKLOAD_WORKSPACE=${3} # $(yq r ${PARAMS_YAML} musicstore.tmc-workspace)

OKTA_API_KEY=$(yq r ${PARAMS_YAML} okta.api-keya)
OKTA_AUTH_SERVER_CN=$(yq r ${PARAMS_YAML} okta.auth-server-fqdn)

SHARED_SERVICES_CLUSTER=$(yq r ${PARAMS_YAML} tmc.shared-services-cluster)
WORKLOAD_CLUSTER=$(yq r ${PARAMS_YAML} tmc.workload-cluster)

function check_okta_group() {
    local name="${1}"
    local first="$(curl --silent --location --get "https://${OKTA_AUTH_SERVER_CN}/api/v1/groups" \
      --header 'Accept: application/json' \
      --header "Authorization: SSWS ${OKTA_API_KEY}" \
      --data "q=${name}" | jq -r ".[0].profile.name")"
    [[ ${first} == ${name}  ]]
}

function add_okta_group() {
    local name="${1}"
    local description="${2}"
    local group="$(jq -n --arg name "${name}" \
                         --arg description "${description}" \
                         -f okta/group.json)"

    curl --silent --location --request POST "https://${OKTA_AUTH_SERVER_CN}/api/v1/groups" \
      --header 'Accept: application/json' \
      --header 'Content-Type: application/json' \
      --header "Authorization: SSWS ${OKTA_API_KEY}" \
      --data-raw "${group}" > /dev/null
}

function check_workspace() {
    local name="${1}"
    tmc workspace get "${name}" 2>/dev/null
 }

function add_workspace() {
    local name="${1}"
    local description="${2}"

    tmc workspace create --name "${name}" --description "${description}"
}

function check_namespace() {
    local cluster="${1}"
    local workspace="${2}"
    local name="${3}"
    tmc cluster namespace get "${name}" --cluster-name ${cluster} \
        --management-cluster-name attached  --provisioner-name attached 
}

function add_namespace() {
    local cluster="${1}"
    local workspace="${2}"
    local name="${3}"
    local description="${4}"

    tmc cluster namespace create --name "${name}" --description "${description}" \
        --workspace-name ${workspace} --cluster-name ${cluster} \
        --management-cluster-name attached  --provisioner-name attached
}

OKTA_GROUP="${TEAM}-devs"
if ! check_okta_group "${OKTA_GROUP}" ; then
    add_okta_group "${OKTA_GROUP}" "Steeltoe music store development team"
fi

CONCOURSE_MAIN_TARGET=$(yq r ${PARAMS_YAML} common.concourseMainTarget)
if [[ -z $(fly -t ${CONCOURSE_MAIN_TARGET} teams --json | jq -r --arg team ${TEAM} '.[] | select ( .name == $team ) .name') ]] ; then
    fly -t ${CONCOURSE_MAIN_TARGET} set-team --team-name ${TEAM} --oidc-group ${TEAM}-devs --oidc-group platform-team --non-interactive
fi

if ! check_workspace ${WORKLOAD_WORKSPACE} ; then
    add_workspace ${WORKLOAD_WORKSPACE} "Steeltoe music store"
fi

if ! check_namespace ${WORKLOAD_CLUSTER} ${WORKLOAD_WORKSPACE} ${TEAM} ; then
    add_namespace ${WORKLOAD_CLUSTER} ${WORKLOAD_WORKSPACE} ${TEAM} "Steeltoe music store production"
fi

STAGING_NAMESPACE=${TEAM}-staging
if ! check_namespace ${WORKLOAD_CLUSTER} ${WORKLOAD_WORKSPACE} ${STAGING_NAMESPACE} ; then
    add_namespace ${WORKLOAD_CLUSTER} ${WORKLOAD_WORKSPACE} ${STAGING_NAMESPACE} "Steeltoe music store staging"
fi

SECRETS_NAMESPACE=concourse-${TEAM}
if ! check_namespace ${SHARED_SERVICES_CLUSTER} ${PLATFORM_WORKSPACE} ${SECRETS_NAMESPACE} ; then
    add_namespace ${SHARED_SERVICES_CLUSTER} ${PLATFORM_WORKSPACE} ${SECRETS_NAMESPACE} "Steeltoe music store concourse secret store"
fi

TBS_NAMESPACE=tbs-project-${TEAM}
HARBOR_DOMAIN=$(yq r $PARAMS_YAML commonSecrets.harborDomain)
REGISTRY_USER=$(yq r $PARAMS_YAML commonSecrets.harborUser)
REGISTRY_PASSWORD=$(yq r $PARAMS_YAML commonSecrets.harborPassword)
if ! check_namespace ${SHARED_SERVICES_CLUSTER} ${PLATFORM_WORKSPACE} ${TBS_NAMESPACE} ; then
    add_namespace ${SHARED_SERVICES_CLUSTER} ${PLATFORM_WORKSPACE} ${TBS_NAMESPACE} "Steeltoe music store TBS build namespace"
    kp secret create harbor-creds \
      --registry $HARBOR_DOMAIN \
      --registry-user $REGISTRY_USER \
      --namespace $TBS_NAMESPACE
fi


SHAREDSVC_CLUSTER_NAME=$(yq r ${PARAMS_YAML} clusters.shared-services-cluster)
PREVIOUS_CONTEXT=$(kubectl config current-context)
# Install secrets in Shared Services Cluster
kubectl config use-context $SHAREDSVC_CLUSTER_NAME-admin@$SHAREDSVC_CLUSTER_NAME

ytt -f concourse/team -f ${PARAMS_YAML} -v common.team=${TEAM} --ignore-unknown-comments | 
    kapp deploy -n tanzu-kapp -a concourse-team-${TEAM} -f - -y

kubectl config use-context ${PREVIOUS_CONTEXT}
