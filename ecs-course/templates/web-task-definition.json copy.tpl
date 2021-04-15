[
  {
    "name": "nginx",
    "image": "${repository_url}",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "memory": 50,
    "cpu": 102
  }
]