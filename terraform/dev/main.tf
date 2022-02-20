terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.74.1"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "default"
  #   shared_credentials_file = "/root/terraform/.aws/credentials"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-west-2a"
  tags = {
    "Terraform" : "true"
    "Prod" : "false"
  }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-west-2b"
  tags = {
    "Terraform" : "true"
    "Prod" : "false"
  }
}

resource "aws_security_group" "faceit" {
  name        = "faceit"
  description = "Allow standart http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
    "Prod" : "false"
  }
}
resource "aws_elb" "faceit" {
  name            = "faceit"
  subnets         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.faceit.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags = {
    "Terraform" : "true"
    "Prod" : "false"
  }
}

#Amazon ECS-Optimized Amazon Linux 2 AMI
resource "aws_launch_template" "faceit" {
  name_prefix   = "prod-web"
  image_id      = "ami-0b250f625dc7f2bc9"
  instance_type = "t2.micro"
  tags = {
    "Terraform" : "true"
  }
}


# provider "docker" {}

#pull the image from hub.docker.com
resource "docker_image" "faceit" {
  name         = "anatolman/faceit:0.1.122"
  keep_locally = false
}

#create a container
resource "docker_container" "faceit" {
  image = docker_image.faceitapp.latest
  name  = "faceit"
  ports {
    internal = 8080
    external = 8080
  }
  env {
    POSTGRESQL_HOST     = localhost
    POSTGRESQL_PORT     = 5432
    POSTGRESQL_USER     = postgres
    POSTGRESQL_PASSWORD = mysecretpassword
    POSTGRESQL_DBNAME   = postgres
  }
}
