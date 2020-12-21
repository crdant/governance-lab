# Install TBS and Dependencies

We use Tanzu Build Service to build the application image in a 
Concourse pipeline. We're also going to show how we can upgrade
the TBS stack and builder to deploy a more secure application
container without having to rebuild the application. We need 
to install TBS into the shared services cluster to along with
two versions of it's dependencies.

## Run the Setup Script

Install TBS using the setup script. This script downloads TBS
and it's dependencies from the Tanzu network, deploys TBS to the
shared service cluster, and stores dependencies in your registry.

```
deploy-tbs.sh $(yq r ${PARAMS_YAML} clusters.shared-services-cluster)
```

The standard TBS install creates a set of `clusterstack` and
`clusterbuilder` objects using the current set of dependencies.
Running the script also sets up and example `clusterstack` 
with out of date dependencies and a builder that uses it. We'll
use these for the first run through our build process to
later mimic how we can resolve issues by upgrading TBS.

## Validate Setup

```
kp clusterbuilder list
```

## Next Step

[Setup the environment for the Petclinic development team](docs/03-setup-team.sh) 
