package main

deny[msg] {
    is_ingress(input)

    ingress := input
    not https_complete(ingress)
    msg := sprintf("Ingress should be https. tls configuration required for %v", [ingress.metadata.name])
}

is_ingress(object) = true {
    object.kind == "Ingress"
    re_match("^(extensions|networking.k8s.io)", object.apiVersion)
}

https_complete(ingress) = true {
    ingress.spec["tls"]
    count(ingress.spec.tls) > 0
}

deny[msg] {
    is_ingress(input)

    ingress := input
    count(ingress.metadata.annotations) > 0
    allow_http(ingress)
    not force_redirect(ingress)
    msg := sprintf("Ingress should be https. Annotation force-ssl-redirect=true or allow-https=false required for %v", [ingress.metadata.name])
}

allow_http(ingress) = true {
    ingress.metadata.annotations["kubernetes.io/ingress.allow-http"] == "true"
}

force_redirect(ingress) = true {
    ingress.metadata.annotations["ingress.kubernetes.io/force-ssl-redirect"] 
    ingress.metadata.annotations["ingress.kubernetes.io/force-ssl-redirect"] == "true"
}
