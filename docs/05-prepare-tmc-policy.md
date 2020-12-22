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

## Assign the Policies Manually

Unfortunately, the TMC CLI won't allow us to assign the custom policies
to the appropriate cluster group. Instead, you'll have to do it using 
the TMC GUI. Log into TMC, and navigate to "Policies > Assignments" 
then select the "Custom" tab.  Find your workload cluster group under
clusters and click on it.

You're going to add each of the policies that we loaded templates for
in the previous step. All of their names were output at the end. For each
one, you'll want to click on the "Create Custom Policy Link" and select 
the policy template name from the dropdown. You'll need to select the kind
and API group it applies to according to this table, and fill in any of
the required parameters. Each name is prefaced with your environment.

| Policy                   | Kind       | API Group         | Parameters   | 
|--------------------------|------------|-------------------|--------------|
| deploymentreplicaminimum | Deployment | apps              | Replicas: 3  |
| httpsonly                | Ingress    | netorking.k8s.io  |              |
|                          | Ingress    | extensions        |              |

We're also going to coax TMC into enforcing these at the workspace level 
by using a label selector on the label "tmc.cloud.vmware.com/workspace". 
Add that selector and set the value to your workload workspace 
`${ENVIRONMENT}-${TEAM}`.

## Next Step 

[Deploy Sonarqube](06-deploy-sonarqube.md) 
