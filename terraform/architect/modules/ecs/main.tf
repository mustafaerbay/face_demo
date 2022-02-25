module "network" {
  source               = "../network"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  depends_id           = ""
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster
}