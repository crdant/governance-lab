# Deploy Sonarqube

The Lab uses Sonarqube for static code scanning. It's widely used and 
open source, so makes an easy choice for the demonstration. Since it's
a shared tool, we'll deploy it to the shared services cluster. There 
is no Helm chart or other supported Kubernetes distribution, so this
repository includes the deployment artifacts to get it running.

## Run the Deploy Script

The `deploy-sonarqube.sh` script deploys Sonarqube from a Bitnami 
image that's been replicated to your local registry. It deploys 
PostgreSQLdatabase with the Bitnami Helm chart.

```
deploy-sonarqube.sh $(yq r ${PARAMS_YAML} clusters.shared-services-cluster)
```

## Validate Setup

You can validate the install by logging into Sonarqube with the username 
admin and the password you specified in your paramter file.

```
open https://$(yq r ${PARAMS_YAML} sonarqube.host)
```

## Next Step

[Push the policy bundle to the registry](docs/06-push-policy-bundle.md) 

