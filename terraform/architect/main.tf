locals {
  name_prefix = var.name_prefix
  default_tags = {
    Terraform = "true"
    Owner     = var.owner
  }
}

#TODO: move to versions.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "= 3.74.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  profile = "default"
  shared_credentials_file = "/root/terraform/.aws/credentials"
}

#This block will grab availability zones that are available to your account
#It's best practice to use multiple availability zones when deploying tasks to an AWS ECS Fargate cluster because Fargate will ensure high availability by spreading tasks of the same type as evenly as possible between availability zones
data "aws_availability_zones" "available_zones" {
  state = "available"
}

#Resources that will be created will be defined inside of the VPC. An AWS VPC provides logical isolation of resources from one another. All of the resources that will be defined will live within the same VPC. Four subnets will be created next. Two will be public and the other two will be private, where each availability zone will have one of each
resource "aws_vpc" "default" {
  cidr_block = "10.32.0.0/16"
}


#Things that should be public-facing, such as a load balancer, will be added to the public subnet. Other things that don't need to communicate with the internet directly, such as a "Faceit backend" service defined inside an ECS cluster, will be added to the private subnet. 
resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.default.id
}

#The internet gateway, for example, is what allows communication between the VPC and the internet at all. 
#That is all tied together with the route table association, where the private route table that includes the NAT gateway is added to the private subnets defined earlier. Security groups will need to be added next to allow or reject traffic in a more fine-grained way both from the load balancer and the application service. 
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_eip" "gateway" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}

##The NAT gateway allows resources within the VPC to communicate with the internet but will prevent communication to the VPC from outside sources.
resource "aws_nat_gateway" "gateway" {
  count         = 2
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

#The load balancer's security group will only allow traffic to the load balancer on port 80, as defined by the ingress block within the resource block. Traffic from the load balancer will be allowed to anywhere on any port with any protocol with the settings in the egress block. 
resource "aws_security_group" "lb" {
  name        = "example-alb-security-group"
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#aws_lb defines the load balancer itself and attaches it to the public subnet in each availability zone with the load balancer security group.
resource "aws_lb" "default" {
  name            = "example-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

#The target group, when added to the load balancer listener tells the load balancer to forward incoming traffic on port 80 to wherever the load balancer is attached. In this case, it will be the ECS service defined later.
resource "aws_lb_target_group" "hello_world" {
  name        = "example-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"
}

resource "aws_lb_listener" "hello_world" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.hello_world.id
    type             = "forward"
  }
}

#The task definition defines how the hello world application should be run. This is where it's specified that the platform will be Fargate rather than EC2, so that managing EC2 instances isn't required. This means that CPU and memory for the running task should be specified. The image used is a simple API that returns "Hello World!" and is available as a public Docker image. The Docker container exposes the API on port 3000, so that's specified as the host and container ports. The network mode is set to "awsvpc", which tells AWS that an elastic network interface and a private IP address should be assigned to the task when it runs. 
resource "aws_ecs_task_definition" "hello_world" {
  family                   = "hello-world-app"
  network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 1024
#   memory                   = 1024

  container_definitions = <<DEFINITION
[
  {
    "image": "heroku/nodejs-hello-world",
    "cpu": 10,
    "memory": 512,
    "name": "hello-world-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

#The security group for the application task specifies that it should be added to the default VPC and only allow traffic over TCP to port 3000 of the application. 
resource "aws_security_group" "hello_world_task" {
  name        = "example-task-security-group"
  vpc_id      = aws_vpc.default.id

#The ingress settings also include the security group of the load balancer as that will allow traffic from the network interfaces that are used with that security group
  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################################################################################
#https://towardsaws.com/aws-ecs-service-autoscaling-terraform-included-d4b46997742b


#First of all, you need a role with a policy to handle the autoscaling via the service application-autoscaling.amazonaws.com. This means you permit the autoscaling service to adjust the desired count of your ECS Service based on Cloudwatch metrics.
resource "aws_iam_role" "ecs-autoscale-role" {
  name = "ecs-scale-application"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

#This means you define a role that can be assumed by the application autoscaling service and gets the policy AmazonEC2ContainerServiceAutoscaleRole attached. This policy has all the necessary permissions:
resource "aws_iam_role_policy_attachment" "ecs-autoscale" {
  role = aws_iam_role.ecs-autoscale-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.hello_world.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs-autoscale-role.arn
}


#Once the average CPU or memory consumption jumps above 80% as defined, the desired count gets scaled out to the value 2. If both values fall below this limit the autoscaling reduces the desired count value to 1.
resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  name               = "application-scaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}
resource "aws_appautoscaling_policy" "ecs_target_memory" {
  name               = "application-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

##########################################################################################################

#Amazon ECS-Optimized Amazon Linux 2 AMI
#ami-0b250f625dc7f2bc9
resource "aws_launch_template" "hello_world" {
  name_prefix   = "prod-web"
  image_id      = "ami-0b250f625dc7f2bc9"
  instance_type = "t2.micro"
  tags = {
    "Terraform" : "true"
  }
}

#You must specify either launch_configuration, launch_template, or mixed_instances_policy.
resource "aws_autoscaling_group" "hello_world" {
  availability_zones  = ["us-west-2a", "us-west-2b"]
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.hello_world.id
    version = "$Latest"
  }
  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle { 
    ignore_changes = [desired_capacity, target_group_arns]
  }
}

# resource "aws_autoscaling_attachment" "hello_world" {
#   autoscaling_group_name = aws_autoscaling_group.hello_world.id
#   alb_target_group_arn    = aws_lb_target_group.hello_world.arn
# }

########

resource "aws_ecs_cluster" "main" {
  name = "example-cluster"
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello_world.arn #ARN: Amazon Resource Name
  desired_count   = var.app_count
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50
#   launch_type     = "EC2" default ec2
# if launch_type is specified the capacityProviderStrategy parameter must be omitted

  network_configuration {
    security_groups = [aws_security_group.hello_world_task.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hello_world.id
    container_name   = "hello-world-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.hello_world]
}

#https://github.com/hashicorp/terraform-provider-aws/issues/5561