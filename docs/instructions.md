# Setup Instructions

Since we build on the work of others, we have to run some steps from 
their repositories before we get started.

0. [Setup the Foundational Lab and Bonus Labs](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation/blob/main/00-tkg-lab-foundation.md), 
   follow the steps as document in [@doddatpivotal's repository](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation) and its
   references to the [original lab](https://github.com/Tanzu-Solutions-Engineering/tkg-lab).
1. [Configure parameters for this lab](01-lab-parameter-setup.md) another step
   where I lean heavily on [@doddatpivotal](https://github.com/doddatpivotal) since 
   my parameter file is adapted from his.
2. [Prepare your Harbor registry](02-prepare-registry.md) with the required 
   Okta users, projects, and replications.
3. [Install TBS and it's dependencies](03-install-tbs.md) onto the shared 
   services cluster. This step also creates a stack and builder using older 
   dependencies so we can demonstrate how new TBS dependencies can resolve CVEs without 
   developers rebuilding.
4. [Setup the environment for the Petclinic development team](04-setup-team.md). 
   Creates dependencies for the development team in Okta, Concourse, TMC, and both 
   the workload and shared services clusters.
5. [Prepare TMC policy](05-prepare-tmc-policy.md) to allow access to the cluster, 
   enforce deployment minimums, and one allow workloads from the private registry.
6. [Deploy Sonarqube](06-deploy-sonarqube.md) to the shared service cluster. 
   Sonarqube is used in the pipeline to run as static code scan before building an 
   image from the application.
7. [Push the policy bundle](07-push-policy-bundle.md) to to registry. The bundle
   contains a set of simple resiliency policies that the pipeline will use to
   validate Kubernetes artifacts.
8. [Setup Concourse secrets and pipeline](08-set-pipeline.md). The script 
   both sets the secrets in Kubernetes and set the pipeline in Concourse so they'll
   each be up-to-date and in sync.
