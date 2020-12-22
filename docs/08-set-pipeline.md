# Setup Concourse CI/CD

Now that all of the dependencies are in place, we're ready to set 
Concourse up for CI/CD of the Spring Pet Clinic. This step will 
update the Concourse secrets stored in Kubernetes, load the pipeline
into Concourse, and unpause the pipeline. It should begin to run
soon thereafter.

## Run the Setup Script

The script `set-pipeline.sh` uses `kapp` to set Concourse secrets in
Kubernetes and then sets up the pipeline in Concourse in the team
that the add team script created.

```
set-pipeline.sh
```

Your demo is effectively running now, since the pipeline should 
trigger from the latest commit to the Spring Pet Clinic repository.
