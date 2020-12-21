# Tanzu Governance and Compliance Demo Environment

Provides a lab environment for demonstrating governance and compliance
for a Java application deployed to the VMware Tanzu Platform. The lab
builds upon the great work my colleauges have done on [TKG Lab](https://github.com/Tanzu-Solutions-Engineering/tkg-lab)
and on creating an [end-to-end demonstration of the developer and 
operator experience](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation)
showcasing Tanzu.

# Standing Up the Lab

Since we build on the work of others, we have to run some steps from 
their repositories before we get started.

0. [Setup the Foundational Lab and Bonus Labs](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation/blob/main/docs/00-tkg-lab-foundation.md), 
   follow the steps as document in [@doddatpivotal's repository](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation) and its
   references to the [original lab](https://github.com/Tanzu-Solutions-Engineering/tkg-lab).
1. [Configure parameters for this lab](docs/01-lab-parameter-setup.md) another step
   where I lean heavily on [@doddatpivotal](https://github.com/doddatpivotal) since my parameter file is adapted
   from his.
2. [Install TBS and it's dependencies](docs/02-install-tbs.md).
