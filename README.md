# PS-INFRA

This repository contains the necessary terraform scripts to create infrastructure for deploying `ps-app.`

**Warning: This repository's Cloud Build pipeline shall be run after `ps-app`'s.
This will make sure that the app container image and helm charts are available in GCR prior to infrastructure
creation**.

## Prerequisites
- Terraform v0.14.2 (v0.12+)
- A GCP project with an active billing account.
- Google Cloud Build (for CI pipeline).
  The [GitHub plugin](https://github.com/marketplace/google-cloud-build) has been used for development purposes.
  
### Essential preliminary steps

**Warning: Failure to run the following commands might result in a broken run**

The following commands will make sure that the Google Cloud Build's service account
will have the necessary permissions to create infrastructure in the GCP Project.

```shell
CLOUDBUILD_SA="$(gcloud projects describe [PROJECT_ID] \
--format 'value(projectNumber)')@cloudbuild.gserviceaccount.com"

gcloud projects add-iam-policy-binding [PROJECT_ID] \
--member serviceAccount:$CLOUDBUILD_SA --role roles/editor
```

## Run

Running the pipeline will create the relevant infrastructure and deploy `ps-app`.
Please use the Kubernetes ingress' IP address to reach the application.

## Autoscaling

## Pod horizontal autoscaler

The application has already been configured to automatically autoscale horizontally based on load.
The number of replicas will be increased as configured in the relevant resource.

## Node autoscaler

Exhaustion of node resources will trigger the creation of multiple nodes automatically as configured
in terraform.