# Prepare Your Registry

The Harbor registry is as key control point in the Lab. We use it to
scan images and enforce it as a the only source for workloads in the
workload cluster. It's also where TBS stores it dependencies and how
we store the policy bundle we use with `conftest`. The Lab needs a few
projects and replications in place before we begin.

## About Registry Users

The registry is configured to use OIDC, which means that users must
authenticate via a browser and us the UI to retrieve their CLI token
before accessing the registry with `docker login`. The CLI token is
also the password that TBS will use to interact with the registry if
using an OIDC account.

Robot accounts are an alternative and are a good idea when you only
need to access a single project. Strictly speaking, we could use
robot accounts in the lab since the only place we need to push is the
project for Spring Pet Clinic. I have opted to use OIDC users in my
lab in the event I want to tighten down the registry so that all 
pulls require authentication as well.

When using OIDC accounts, you need to create them in Okta and then
log into the Registry as that user to retrieve the CLI token from
the profile editor. I use incognito windows to do this for a Tanzu
account (used by build service) and a Concourse account (used by
pipelines). This is begging for automation, or for dropping in 
favor of robot accounts. We'll see where it ends up.

## Run the Setup Script

There's as simple script to set up Harbor. It doesn't take any
arguments, but does presume that you will call the API with your
admin user and the admin user's password is in the environment
variable `HARBOR_PASSWORD`.

```
// Since I work on a Mac and use 1Password, I copy the password and run
export HARBOR_PASSWORD=$(pbpaste)
// then run the command
setup-harbor.sh
```

## Next Step

[Install TBS and it's dependencies](03-install-tbs.md).

