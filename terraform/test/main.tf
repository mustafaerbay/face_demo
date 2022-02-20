terraform {
  required_providers {
    # docker = {
    #   source  = "kreuzwerker/docker"
    #   version = "= 2.16.0"
    # }
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.74.1"
    }
    dockerhub = {
      source = "BarnabyShearer/dockerhub"
      version = "0.0.8"
    }
  }
}

# provider "docker" {
#   host = "unix:///var/run/docker.sock"
# }

resource "aws_launch_template" "faceit" {
  name_prefix   = "prod-web"
  image_id      = "ami-0b250f625dc7f2bc9"
  instance_type = "t2.micro"
  tags = {
    "Terraform" : "true"
    "Prod" : "false"
  }
  user_data = <<-EOF
    #!/bin/bash
    docker run -d --name=faceit --env POSTGRESQL_HOST=192.168.1.107  anatolman/faceit:0.1.170
  EOF
}

provider "aws" {
  region  = "us-west-2"
  profile = "default"
  #   shared_credentials_file = "/root/terraform/.aws/credentials"
}


#### dockerhub
# provider "dockerhub" {
#   # Configuration options
#   username = ""
#   password = ""
# }

# resource "dockerhub_repository" "example" {
#   namespace = "anatolman"
#   name             = "anatolman/faceit:0.1.167"
#   description      = "Example repository for faceit"
#   full_description = "Readme."
# }

# resource "dockerhub_token" "example" {
#   label = "example"
#   scopes = ["repo:admin"]
# }
#### dockerhub

#pull docker image
# resource "docker_image" "faceit" {
#   name         = "anatolman/faceit:0.1.122"
#   keep_locally = false
# }

# #create a container
# resource "docker_container" "faceit" {
#   image = docker_image.faceit.latest
#   name  = "faceit"
#   ports {
#     internal = 8080
#     external = 8080
#   }
#   env = [
#     "POSTGRESQL_HOST     = localhost",
#     "POSTGRESQL_PORT     = 5432",
#     "POSTGRESQL_USER     = postgres",
#     "POSTGRESQL_PASSWORD = mysecretpassword",
#     "POSTGRESQL_DBNAME   = postgres"
#   ]
# }