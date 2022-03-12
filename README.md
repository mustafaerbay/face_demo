# face_demo

There are two different CI pipelines here.
## **CI**
### Circle CI Pipeline

The stages below are handled with shell [script](/test-app/build.sh) faceit image has been pushed to the docker hub with the tag of circleci build id (0.1.289)
- build
- test
- push

![Alt text](/screenshots/circleci_dashboard.png?raw=true "Circle CI Dashboard")

![Alt text](/screenshots/docker_hub_image_list.png?raw=true "Docker Hub image tags")

### **Github CI Pipeline**
You can find the different pipeline approaches for different SDLC under [workflows](/.github/workflows/) folder

#### Purpose of actions yaml
[ci yaml](/.github/workflows/ci.yml)
- Build image 
- Test connections with database
- Push to docker hub with short commit id and latest_github tag

[push image to ECR yaml](/.github/workflows/push_image_to_ecr.yml)
- Run if ci.yaml success
- Build and push to AWS ECR

[Validate terraform files](/.github/workflows/validate_terraform_files.yml)

Terraform validate should be done before the production stage
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

## **CD**
### **Github ActionsContinuous Deployment (CD)**
[Terraform deploy yaml](/.github/workflows/terraform.yml)
could be used for deployment 

### **Terraform Deployment**
You can follow [Terraform Readme file](/terraform/readme.md) to execute terraform deployment

### Deployment Diagram
![Alt text](/screenshots/latest_faceit_draw.png?raw=true "AWS diagram")



