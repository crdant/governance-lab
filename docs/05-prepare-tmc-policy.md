# Prepare TMC Policy

TMC shines as a control point for governance and compliance in your 
cluster. We're going to show off a few of it's feature in the lab:

* _Access Control_: Assigning the development team acccess to the
clusters and namespaces they need to do their work.
* _Image Policy_: Enforcing image trust by only allowing workloads
to come from the private registry
* _Custom Policy_: Encouraging resiliency by enforcing a minimum of
three replicas on application deployments using a custom OPA policy
template. Also increasing security by requiring HTTPS for all ingress
objects. 

The custom policies we enforce at runtime are the same effective 
policies validated by `conftest` during build time (see [push policy
bundle](07-push-policy-bundle.md)).

## Run the Prepare TMC Policy Script

There's as simple script to prepare TMC. It will set up the policy
templates and policy assignments needed for the demonstration.

```
prepare-tmc-policy.sh
```

If you read the script and/or the templates it uses, you'll see that
the custom policy templates use a "magic string" and `sed` while the
others use `ytt` for YAML-aware templating. This is intentional. I
started out using `ytt` for everything but the policy templates would
then load into TMC with the Rego string compressed and escaped. Since
you'll want to show the templates as part of your demo I wanted to
keep the Rego readable as a multi-line string and used a more naive
approach.

## Next Step 

[Deploy Sonarqube](06-deploy-sonarqube.md) 
