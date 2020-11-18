package main

replicas := 3

is_deployment(object) = true {
    object.kind == "Deployment"
    re_match("^(apps)", object.apiVersion)
}

deny[msg] {
    is_deployment(input)
    deployment := input
    name := deployment.metadata.name
    deployment.spec.replicas < replicas
    msg := sprintf("To meet resiliency standards, %v must run at least %v instances", [name, replicas])
}