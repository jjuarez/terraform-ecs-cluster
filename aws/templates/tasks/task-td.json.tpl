[
  {
    "name": "${name}",
    "essential": true,
    "cpu": ${cpu},
    "memory": ${memory},
    "image": "${image_url}",
    "environment": ${environment},
    "portMappings": [
      {
        "containerPort": ${port},
        "protocol": "${protocol}"
      }
    ],
    "logConfiguration": {
      "logDriver": "${log_driver}",
      "options": {
        "awslogs-group": "${log_group_name}",
        "awslogs-region": "${log_group_region}"
      }
    }
  }
]
