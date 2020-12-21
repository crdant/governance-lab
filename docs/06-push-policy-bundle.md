# Push Policy Bundle

Like our code, we also want to do some validation on the Kubernetes
artifacts we're using to run it. The tool `conftest` runs OPA policies
against a set of files to validate that they are compliant. Our 
pipeline includes a step that runs a set of policies against the 
Kubernetes manifests we use to deploy the Petclinic application.

The `conftest` task in the pipeline uses an OPA bundle from the 
private registry. We need to push the bundle the Harbor (which can 
store it because it's OCI-compliant) before we run the pipeline.

## Run the Push Policy Script

The script `push-policies.sh` uses Docker to invoke `conftest` and 
push a policy bundle to the registry.

```
push-policies.sh
```

All policies in the directoy `conftest/policy` will be pushed, so
you can add your own if there's something you'd like to highlight in
your demonstration

