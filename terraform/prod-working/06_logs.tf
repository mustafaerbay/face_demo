resource "aws_cloudwatch_log_group" "faceit-backend-log-group" {
  name              = "/ecs/faceit-backend"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "faceit-backend-log-stream" {
  name           = "faceit-backend-log-stream"
  log_group_name = aws_cloudwatch_log_group.faceit-backend-log-group.name
}

# resource "aws_cloudwatch_log_group" "nginx-log-group" {
#   name              = "/ecs/nginx"
#   retention_in_days = var.log_retention_in_days
# }

# resource "aws_cloudwatch_log_stream" "nginx-log-stream" {
#   name           = "nginx-log-stream"
#   log_group_name = aws_cloudwatch_log_group.nginx-log-group.name
# }
