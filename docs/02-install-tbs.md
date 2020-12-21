# Install TBS and Dependencies

We use Tanzu Build Service to build the application image in a 
Concourse pipeline. We're also going to show how we can upgrade
the TBS stack and builder to deploy a more secure application
container without having to rebuild the application. We need 
to install TBS into the shared services cluster to along with
two versions of it's dependencies.

## Run the Setup Script

```
deploy-tbs.sh $(yq r ${PARAMS_YAML} clusters.shared-services-cluster)
```

## Validate Setup

```
kp clusterbuilder list
```

