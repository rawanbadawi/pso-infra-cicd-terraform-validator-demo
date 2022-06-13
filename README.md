# Deploy a simple container with DevSecOps terraform pipeline

This repository shows how to use terraform validator when deploying infrastructure as code using terraform. The benefit of using a security testing suite 

## Pre-requisites
* A Google Cloud Project
* gcloud cli installed
* The following apis enabled in the GCP project: cloudbuild, containerregistry, and artifactregistry

```bash
gcloud services enable cloudbuild.googleapis.com \ 
containerregistry.googleapis.com \
storage-component.googleapis.com \
artifactregistry.googleapis.com \
```

* fork the following repository: https://github.com/rawanbadawi/pso-infra-cicd-terraform-validator-demo

* Clone your repo in cloud shell or locally:

* Install the google cloudbuild github app: https://cloud.google.com/build/docs/automating-builds/build-repos-from-github#installing_gcb_app

* create a cloudbuild trigger from the repository:
```
gcloud beta builds triggers create github \
    --name=test-terraform \
    --repo-name=pso-infra-cicd-terraform-validator-demo \
    --repo-owner=REPOSITORYOWNER \
    --pull-request-pattern=^main$ \
    --build-config=cloudbuild_test.yaml \
    --comment-control=COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY
```
```
gcloud beta builds triggers create github \
    --name=deploy-iac \
    --repo-name=pso-infra-cicd-terraform-validator-demo \
    --repo-owner=REPOSITORYOWNER \
    --branch-pattern=^main$ \
    --build-config=cloudbuild_deploy.yaml \
    --comment-control=COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY
```
* Create an artifact repository for the terraform vet image:

```bash
gcloud artifacts repositories create terraform-vet --repository-format=docker \
--location=us-central1 --description="Repository terraform vet"

```

* Build the terraform vet container (Note replace <project-id> with your project ID):

```bash
cd terraform-vet/
gcloud builds submit --region=us-central1 --tag us-central1-docker.pkg.dev/<project-id>/terraform-vet/terraform-vet .

```
* create a gcs bucket to host the terraform state file replace <bucket-name> with a unique bucket name:

``` bash
gsutil mb -c standard -l us-central1 gs://<bucket-name>

```

## Usage

1. Create a branch of your repo 
``` 
git checkout -b test-iac
```
1. Edit `TFSTATE_BUCKET` in `deployments/app1/backend.tf` file to the bucket name created above
1. Change the `image` value to the container image you wish to deploy to in `deployments/app1/terraform.tfvars` 
1. Commit the changes and create a pull request
``` bash
git add --all
git commit -m"testing IaC devsecops pipelines"
git push origin test-iac
```
1. Verify the build fails as the cloudrun api is not an approved API as per constraints 
1. Update the constraint file:  
``` bash
echo '    - "run.googleapis.com"' >> policy-library/policies/constraints/serviceusage_allow_basic_apis.yaml

```
1. commit the changes to the branch
1. Verify the build passes 
1. Merge to main the cloud build should run and create the infrastructure