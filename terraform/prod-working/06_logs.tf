resource "aws_cloudwatch_log_group" "faceit-backend-log-group" {
  name              = "/ecs/faceit-backend"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "faceit-backend-log-stream" {
  name           = "faceit-backend-log-stream"
  log_group_name = aws_cloudwatch_log_group.faceit-backend-log-group.name
}

