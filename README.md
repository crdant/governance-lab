# Tanzu Governance and Compliance Demo Environment

Provides a lab environment for demonstrating governance and compliance
for a Java application deployed to the VMware Tanzu Platform. The lab
builds upon the great work my colleauges have done on [TKG Lab]
(https://github.com/Tanzu-Solutions-Engineering/tkg-lab) and on creating 
an [end-to-end demonstration of the developer and operator experience]
(https://github.com/doddatpivotal/tkg-lab-e2e-adaptation) showcasing Tanzu.

The Lab uses the [Spring Pet Clinic](https://github.com/spring-projects/spring-petclinic)
application as the codebase for the demonstration. 

# Standing Up the Lab

Since we build on the work of others, we have to run some steps from 
their repositories before we get started.

0. [Setup the Foundational Lab and Bonus Labs](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation/blob/main/docs/00-tkg-lab-foundation.md), 
   follow the steps as document in [@doddatpivotal's repository](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation) and its
   references to the [original lab](https://github.com/Tanzu-Solutions-Engineering/tkg-lab).
1. [Configure parameters for this lab](docs/01-lab-parameter-setup.md) another step
   where I lean heavily on [@doddatpivotal](https://github.com/doddatpivotal) since 
   my parameter file is adapted from his.
2. [Prepare your Harbor registry](docs/02-prepare-registry.md) with the required 
   Okta users, projects, and replications.
3. [Install TBS and it's dependencies](docs/03-install-tbs.md) onto the shared 
   services cluster. This step also creates a stack and builder using older 
   dependencies so we can demonstrate how new TBS dependencies can resolve CVEs without 
   developers rebuilding.
4. [Setup the environment for the Petclinic development team](docs/04-setup-team.md). 
   Creates dependencies for the development team in Okta, Concourse, TMC, and both 
   the workload and shared services clusters.
5. [Prepare TMC policy](05-prepare-tmc-policy.md) to allow access to the cluster, 
   enforce deployment minimums, and one allow workloads from the private registry.
6. [Deploy Sonarqube](docs/06-deploy-sonarqube.md) to the shared service cluster. 
   Sonarqube is used in the pipeline to run as static code scan before building an 
   image from the application.
7. [Push the policy bundle](docs/07-push-policy-bundle.md) to to registry. The bundle
   contains a set of simple resiliency policies that the pipeline will use to
   validate Kubernetes artifacts.
8. [Setup Concourse secrets and pipeline](docs/08-set-pipeline.md). The script 
   both sets the secrets in Kubernetes and set the pipeline in Concourse so they'll
   each be up-to-date and in sync.
