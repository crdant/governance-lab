#!/usr/bin/env bash
set -e

environment=$(yq r ${PARAMS_YAML} environment)
team=$(yq r ${PARAMS_YAML} common.team)
cluster_group=$(yq r ${PARAMS_YAML} tmc.workload-cluster-group)

function set_iam_policy() {
    workspace=${1}
    binding_file=$(gmktemp --suffix .yaml)
    ytt -f tmc/policy/access/workspace-access.yaml -f ${PARAMS_YAML} --ignore-unknown-comments > ${binding_file}
    tmc workspace iam update-policy "${workspace}" -f ${binding_file}
    rm ${binding_file}
}

function set_image_policy() {
    workspace=${1}
    policy_file=$(gmktemp --suffix .yaml)
    ytt -f tmc/policy/image/private-registry.yaml -f ${PARAMS_YAML} --ignore-unknown-comments > ${policy_file}
    cmd="create"
    if tmc workspace image-policy get --workspace-name ${workspace} private-registry 2>/dev/null 1>/dev/null; then
        cmd="update"
    fi
    tmc workspace image-policy ${cmd} --workspace-name "${workspace}" private-registry -f ${policy_file}
    rm ${policy_file}
}

function add_policy_template() {
    template=${1}
    policy_file=$(gmktemp --suffix .yaml)
    # deliberately doing something YAML UNaware to maintain multiline string format
    sed -e "s/ENVIRONMENT/${environment}/g" ${template} > ${policy_file}
    policy_name=$(yq r ${policy_file} metadata.name)
    if ! tmc policy templates get ${policy_name} 2>/dev/null 1>/dev/null ; then 
        tmc policy templates create --object-file ${policy_file}
    fi
    echo "added policy template: ${policy_name}"
    rm ${policy_file}
}

workspace="${environment}-${team}"
set_iam_policy ${workspace}
set_image_policy ${workspace}

template_dir="tmc/policy/template"
for template in $(ls "${template_dir}"); do
    add_policy_template "${template_dir}/${template}"
done

