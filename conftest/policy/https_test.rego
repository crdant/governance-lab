package main

test_allows_http {
    input := {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": "no_http",
            "annotations": {
                "kubernetes.io/ingress.allow-http": "true"
            }
        },
        "spec": {
            "rules": [
                {
                    "host": "service.domain.tld",
                    "http": {
                        "paths": [
                            {
                                "backend": {
                                    "serviceName": "service",
                                    "servicePort": 80
                                },
                            }
                        ]
                    }
                }
            ],
            "tls": [
                {
                    "hosts": [
                        "service.domain.tld"
                    ],
                    "secretName": "service-cert"
                }
            ]
        },
    }
    msg := sprintf("Ingress should be https. Annotation force-ssl-redirect=true or allow-https=false required for %v", [input.metadata.name])
    deny[msg] with input as input
}

test_does_not_allow_http {
    input := {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": "no_http",
            "annotations": {
                "kubernetes.io/ingress.allow-http": "false"
            }
        },
        "spec": {
            "rules": [
                {
                    "host": "service.domain.tld",
                    "http": {
                        "paths": [
                            {
                                "backend": {
                                    "serviceName": "service",
                                    "servicePort": 80
                                },
                            }
                        ]
                    }
                }
            ],
            "tls": [
                {
                    "hosts": [
                        "service.domain.tld"
                    ],
                    "secretName": "service-cert"
                }
            ]
        },
    }
    no_violations with input as input
}

test_force_https_redirect {
    input := {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": "force_https",
            "annotations": {
                "kubernetes.io/ingress.allow-http": "true",
                "ingress.kubernetes.io/force-ssl-redirect": "true"
            }
        },
        "spec": {
            "rules": [
                {
                    "host": "service.domain.tld",
                    "http": {
                        "paths": [
                            {
                                "backend": {
                                    "serviceName": "service",
                                    "servicePort": 80
                                },
                            }
                        ]
                    }
                }
            ],
            "tls": [
                {
                    "hosts": [
                        "service.domain.tld"
                    ],
                    "secretName": "service-cert"
                }
            ]
        },
    }
    no_violations with input as input
}

test_doesnt_force_https_redirect {
    input := {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": "force_https",
            "annotations": {
                "ingress.kubernetes.io/force-ssl-redirect": "false"
            }
        },
        "spec": {
            "rules": [
                {
                    "host": "service.domain.tld",
                    "http": {
                        "paths": [
                            {
                                "backend": {
                                    "serviceName": "service",
                                    "servicePort": 80
                                },
                            }
                        ]
                    }
                }
            ],
            "tls": [
                {
                    "hosts": [
                        "service.domain.tld"
                    ],
                    "secretName": "service-cert"
                }
            ]
        },
    }
    no_violations with input as input
}

test_no_tls {
    input := {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": "no_tls",
        },
        "spec": {
            "rules": [
                {
                    "host": "service.domain.tld",
                    "http": {
                        "paths": [
                            {
                                "backend": {
                                    "serviceName": "service",
                                    "servicePort": 80
                                },
                            }
                        ]
                    }
                }
            ]
        },
    }

    msg := sprintf("Ingress should be https. tls configuration required for %v", [input.metadata.name])
    deny[msg] with input as input
}

test_no_annotations {
    input := {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": "force_https",
        },
        "spec": {
            "rules": [
                {
                    "host": "service.domain.tld",
                    "http": {
                        "paths": [
                            {
                                "backend": {
                                    "serviceName": "service",
                                    "servicePort": 80
                                },
                            }
                        ]
                    }
                }
            ],
            "tls": [
                {
                    "hosts": [
                        "service.domain.tld"
                    ],
                    "secretName": "service-cert"
                }
            ]
        },
    }

    no_violations with input as input
}
