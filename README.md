# face_demo
## Terraform Usage

variables list

|adas|asdas|
|asdas|asds|




There are two different CI pipeline here. 
### Circle CI Pipeline

Below stages handled with shell [script](/test-app/build.sh) faceit image has been pushed to the docker hub with the tag of circleci build id (0.1.289)
- build
- test
- push

![Alt text](/screenshots/circleci_dashboard.png?raw=true "Circle CI Dashboard")

![Alt text](/screenshots/docker_hub_image_list.png?raw=true "Docker Hub image tags")

### Github CI Pipeline
you could find different  pipeline approaches for different SDLC under [workflows](/.github/workflows/) folder

#### Purpose of actions yaml
[ci yaml](/.github/workflows/ci.yml)
- Build image 
- test connections with database
- push to docker hub with short commit id and latest_github tag

[push image to ECR yaml](/.github/workflows/push_image_to_ecr.yml)
- run if ci.yaml success
- build and push to AWS ECR

[Validate terraform files](/.github/workflows/validate_terraform_files.yml)

supposed to be before production stage
- terraform fmt
- terraform init
- terraform validate

[Stale yaml](/.github/workflows/stale.yml)
Runs everyday at 01:30 am

- days-before-issue-stale: 30
- days-before-pr-stale: 45
- days-before-issue-close: 5
- days-before-pr-close: 10

[Terraform deploy yaml](/.github/workflows/terraform.yml)
used for deployment to the AWS with terraform
