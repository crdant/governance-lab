# Setup Lab Parameters

Copy the file `secrets/REDACTED-lab.yml` to `secrets/lab.yml` and update
the file for your lab environment. I've use a few tags in there that you
can easily use to search/replace and fill some things in quickly:

| Tag                              | Usage                                                                 |
|----------------------------------|-----------------------------------------------------------------------|
|`YOUR_WORKLOAD_SUBDOMAIN`         | subdomain your workload cluster users for it's wildcard DNS           |
|`YOUR_SHARED_SERVICES_SUBDOMAIN`  | subdomain your shared services cluster users for it's wildcard DNS    |
|`YOUR_GITHUB_USERNAME`            | username you'll use on Github for the source and package repositories |
|`YOUR_S3_BUCKET_NAME`             | an S3 bucket for storing results of the OWASP ZAP scan                |

Several value are also set to `REDACTED` because sharing my values would
be a bad idea. Set your specific values into those. Most are straightforward,
the only ones to be aware of are the two that start with `kubeconfig` which 
reference a Kubernetes configuration for your build (shared services) and
workload clusters. See [Dodd's docs](https://github.com/doddatpivotal/tkg-lab-e2e-adaptation/blob/main/docs/01-environment-config.md) 
for a quick set of instructions on getting those set up. 

## Next Step

[Install TBS and it's dependencies](docs/02-install-tbs.md).

