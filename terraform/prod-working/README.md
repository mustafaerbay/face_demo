<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.2.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener.ecs-alb-http-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.default-target-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_autoscaling_group.ecs-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.faceit-backend-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.faceit-backend-log-stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_db_instance.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecs_cluster.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_eip.elastic-ip-for-nat-gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs-host-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs-service-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs-instance-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs-service-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.production-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_configuration.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_nat_gateway.nat-gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.nat-gw-route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public-internet-igw-route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private-route-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public-route-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private-route-1-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private-route-2-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-route-1-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-route-2-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.load-balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private-subnet-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private-subnet-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-subnet-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-subnet-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.production-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [template_file.backend](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_hosts"></a> [allowed\_hosts](#input\_allowed\_hosts) | Domain name for allowed hosts | `string` | `"YOUR DOMAIN NAME"` | no |
| <a name="input_amis"></a> [amis](#input\_amis) | Which AMI to spawn. | `map` | <pre>{<br>  "us-west-2": "ami-0b250f625dc7f2bc9"<br>}</pre> | no |
| <a name="input_app_count"></a> [app\_count](#input\_app\_count) | Number of Docker containers to run | `number` | `2` | no |
| <a name="input_autoscale_desired"></a> [autoscale\_desired](#input\_autoscale\_desired) | Desired autoscale (number of EC2) | `string` | `"1"` | no |
| <a name="input_autoscale_max"></a> [autoscale\_max](#input\_autoscale\_max) | Maximum autoscale (number of EC2) | `string` | `"4"` | no |
| <a name="input_autoscale_min"></a> [autoscale\_min](#input\_autoscale\_min) | Minimum autoscale (number of EC2) | `string` | `"1"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b"<br>]</pre> | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | AWS Certificate Manager ARN for validated domain | `string` | `"arn:aws:acm:us-west-2:352898041397:certificate/a5991551-e1ca-45f9-82d2-bba2acf442bb"` | no |
| <a name="input_docker_image_url_faceit_backend"></a> [docker\_image\_url\_faceit\_backend](#input\_docker\_image\_url\_faceit\_backend) | Docker image to run in the ECS cluster | `string` | `"843390642235.dkr.ecr.us-west-2.amazonaws.com/faceit:latest"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name of the ECS cluster | `string` | `"production"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path for the default target group | `string` | `"/health/"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | n/a | `number` | `30` | no |
| <a name="input_private_subnet_1_cidr"></a> [private\_subnet\_1\_cidr](#input\_private\_subnet\_1\_cidr) | CIDR Block for Private Subnet 1 | `string` | `"10.0.3.0/24"` | no |
| <a name="input_private_subnet_2_cidr"></a> [private\_subnet\_2\_cidr](#input\_private\_subnet\_2\_cidr) | CIDR Block for Private Subnet 2 | `string` | `"10.0.4.0/24"` | no |
| <a name="input_public_subnet_1_cidr"></a> [public\_subnet\_1\_cidr](#input\_public\_subnet\_1\_cidr) | CIDR Block for Public Subnet 1 | `string` | `"10.0.1.0/24"` | no |
| <a name="input_public_subnet_2_cidr"></a> [public\_subnet\_2\_cidr](#input\_public\_subnet\_2\_cidr) | CIDR Block for Public Subnet 2 | `string` | `"10.0.2.0/24"` | no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | RDS database name | `string` | `"postgres"` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | RDS instance type | `string` | `"db.t2.micro"` | no |
| <a name="input_rds_password"></a> [rds\_password](#input\_rds\_password) | RDS database password | `string` | `"mysecretpassword"` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | RDS database username | `string` | `"postgres"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to create resources in. | `string` | `"us-west-2"` | no |
| <a name="input_ssh_pubkey_file"></a> [ssh\_pubkey\_file](#input\_ssh\_pubkey\_file) | Path to an SSH public key | `string` | `"~/.ssh/id_rsa.pub"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_hostname"></a> [alb\_hostname](#output\_alb\_hostname) | n/a |
<!-- END_TF_DOCS -->