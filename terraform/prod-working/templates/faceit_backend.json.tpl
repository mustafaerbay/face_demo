[
  {
    "name": "faceit-backend",
    "image": "${docker_image_url_faceit_backend}",
    "essential": true,
    "cpu": 10,
    "memory": 512,
    "links": [],
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "command": ["/app/ops-test-app"],
    "environment": [
      {
        "name": "POSTGRESQL_DBNAME",
        "value": "${rds_db_name}"
      },
      {
        "name": "POSTGRESQL_USER",
        "value": "${rds_username}"
      },
      {
        "name": "POSTGRESQL_PASSWORD",
        "value": "${rds_password}"
      },
      {
        "name": "POSTGRESQL_HOST",
        "value": "${rds_hostname}"
      },
      {
        "name": "POSTGRESQL_PORT",
        "value": "5432"
      },
      {
        "name": "ALLOWED_HOSTS",
        "value": "${allowed_hosts}"
      }
    ],
    "mountPoints": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/faceit-backend",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "faceit-backend-log-stream"
      }
    }
  }
]
