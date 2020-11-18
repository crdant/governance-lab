package main

test_enough_replicas {
    input := { 
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": "spring-petclinic",
            "namespace": "petclinic",
            "labels": {
                "app": "spring-petclinic",
            },
        },
        "spec": {
            "replicas": 3,
            "selector": {
                "matchLabels": {
                    "app": "spring-petclinic",
                }
            },
            "template": {
                "metadata": {
                    "labels": {
                        "app": "spring-petclinic",
                    }
                },
                "spec": {
                    "containers": [
                        {
                            "env": [
                                {
                                    "name": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_URI",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_URI",
                                            "name": "wavefront"
                                        }
                                    }
                                },
                                {
                                    "name": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_API_TOKEN",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_API_TOKEN",
                                            "name": "wavefront"
                                        }
                                    }
                                },
                                {
                                    "name": "WAVEFRONT_APPLICATION_NAME",
                                    "value": "crdant-petclinic"
                                },
                                {
                                    "name": "WAVEFRONT_APPLICATION_SERVICE",
                                    "value": "petclinic"
                                },
                                {
                                    "name": "spring_profiles_active",
                                    "value": "mysql"
                                },
                                {
                                    "name": "MYSQL_URL",
                                    "value": "jdbc:mysql://petclinic-db-mysql/petclinic"
                                }
                            ],
                            "image": "registry.arbol.tanzu.shortrib.io/petclinic/spring-petclinic@sha256:c8b9bfe5f8206169e99ec410c623c9b36f82342e3242f54df737653d170238a5",
                            "livenessProbe": {
                                "failureThreshold": 3,
                                "httpGet": {
                                    "path": "/actuator/health/liveness",
                                    "port": 8080,
                                    "scheme": "HTTP"
                                },
                                "initialDelaySeconds": 25,
                                "periodSeconds": 3,
                                "successThreshold": 1,
                                "timeoutSeconds": 1
                            },
                            "name": "spring-petclinic",
                            "ports": [
                                {
                                    "containerPort": 8080,
                                    "protocol": "TCP"
                                }
                            ],
                            "readinessProbe": {
                                "failureThreshold": 3,
                                "httpGet": {
                                    "path": "/actuator/health/readiness",
                                    "port": 8080,
                                    "scheme": "HTTP"
                                },
                                "initialDelaySeconds": 25,
                                "periodSeconds": 3,
                                "successThreshold": 1,
                                "timeoutSeconds": 1
                            }
                        }
                    ],
                }
            }
        }
    }
    no_violations with input as input
}

test_too_few_replicas {
    input := { 
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": "spring-petclinic",
            "namespace": "petclinic",
            "labels": {
                "app": "spring-petclinic",
            },
        },
        "spec": {
            "replicas": 2,
            "selector": {
                "matchLabels": {
                    "app": "spring-petclinic",
                }
            },
            "template": {
                "metadata": {
                    "labels": {
                        "app": "spring-petclinic",
                    }
                },
                "spec": {
                    "containers": [
                        {
                            "env": [
                                {
                                    "name": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_URI",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_URI",
                                            "name": "wavefront"
                                        }
                                    }
                                },
                                {
                                    "name": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_API_TOKEN",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "MANAGEMENT_METRICS_EXPORT_WAVEFRONT_API_TOKEN",
                                            "name": "wavefront"
                                        }
                                    }
                                },
                                {
                                    "name": "WAVEFRONT_APPLICATION_NAME",
                                    "value": "crdant-petclinic"
                                },
                                {
                                    "name": "WAVEFRONT_APPLICATION_SERVICE",
                                    "value": "petclinic"
                                },
                                {
                                    "name": "spring_profiles_active",
                                    "value": "mysql"
                                },
                                {
                                    "name": "MYSQL_URL",
                                    "value": "jdbc:mysql://petclinic-db-mysql/petclinic"
                                }
                            ],
                            "image": "registry.arbol.tanzu.shortrib.io/petclinic/spring-petclinic@sha256:c8b9bfe5f8206169e99ec410c623c9b36f82342e3242f54df737653d170238a5",
                            "livenessProbe": {
                                "failureThreshold": 3,
                                "httpGet": {
                                    "path": "/actuator/health/liveness",
                                    "port": 8080,
                                    "scheme": "HTTP"
                                },
                                "initialDelaySeconds": 25,
                                "periodSeconds": 3,
                                "successThreshold": 1,
                                "timeoutSeconds": 1
                            },
                            "name": "spring-petclinic",
                            "ports": [
                                {
                                    "containerPort": 8080,
                                    "protocol": "TCP"
                                }
                            ],
                            "readinessProbe": {
                                "failureThreshold": 3,
                                "httpGet": {
                                    "path": "/actuator/health/readiness",
                                    "port": 8080,
                                    "scheme": "HTTP"
                                },
                                "initialDelaySeconds": 25,
                                "periodSeconds": 3,
                                "successThreshold": 1,
                                "timeoutSeconds": 1
                            }
                        }
                    ],
                }
            }
        }
    }
    msg := sprintf("To meet resiliency standards, %s must run at least %s instance", [input.metadata.name, 3])
    deny[msg] with input as input 
}
