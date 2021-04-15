[
  {
    "name": "nginx",
    "image": "nginx:1.18",
    "portMappings": [
      {
        "containerPort": 80
      }
    ],
    "memory": 128,
    "cpu": 256
  },
  {
    "name": "redis",
    "image": "redis:latest",
    "memory": 128,
    "cpu": 256
  }
]