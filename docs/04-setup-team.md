# Setup Team Environment

We need to do a few things to prepare the Lab for a team to build, manage, and
run their workloads. The team needs access to clusters, namespaces to deploy 
to, a registry project, a concourse team, and a few other things setup ahead
of time.

## Run the Add Team Script

The `add-team.sh` script follows a set of conventions that either the Lab 
or the underlying software can rely on. The team name will appear in a lot
of the objects it creates as part of that convention.

```
add-team.sh $(yq r ${PARAMS_YAML} common.team) \
    (yq r ${PARAMS_YAML} tmc.platform-workspace)
```
Assuming $TEAM is your team name (arg 1), $PLATFORM_WORKKSPACE is your
platform workspace in TMC (arg 2), and $ENVIRONMENT is your environment 
name from your parameters file:

* Okta group `${TEAM}-dev`
* Concoure team `$TEAM` that the Okta groups `${TEAM}-dev` and `platform-team`
  are able to access
* TMC workspaces `$PLATFORM_WORKSPACE` and `${ENVIRONMENT}-${TEAM}`. The platform
  should already be there from setting up [TKG Lab](https://github.com/Tanzu-Solutions-Engineering/tkg-lab)
  but if not the script will take care of it.
* Namespaces `$TEAM` and `${TEAM}-staging` in the workload cluster to represent
  production and staging environments. These are managed by TMC and in `${ENVIRONMENT}-${TEAM}`
* Namespace `${TEAM}-secrets` in the shared services cluster that Concourse 
  will look into for secrets for the pipelines in the Concourse team `$TEAM`. 
  It is managed by TMC and in `$PLATFORM_WORKSPACE`, and the service account that
  runs Concourse has access to secrets within it.
* A namespace `tbs-project-${TEAM}` in the shared cluster for TBS builds and
  build artifacts. Like the Concourse secrets namespace it's in `$PLATFORM_WORKSPACE`
  and managed by TMC.

## Validate Setup

You can validate the setup by looking for any/all of the objects above in the
Okta console, TMC, Concourse,. and the two clusters. Some ideas:

```
fly -t $MAIN_TEAM_ALIAS teams
// switch kubernetes context to shared services cluster
kubectl get namespaces
// switch kubernetes context to workload cluster
kubectl get namespaces
tmc get workspaces
```

## Next Step

[Deploy Sonarqube](docs/05-deploy-sonarqube.md) 
