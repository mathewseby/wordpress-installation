resource "aws_ecs_cluster" "wp-ecs" {
  name = "wp-ecs"
}

resource "aws_ecs_task_definition" "service" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = "FARGATE"
  container_definitions = jsonencode([
    {
      name      = "wp"
      image     = "registry.hub.docker.com/library/wordpress:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])

  volume {
    name = "wp-efs-mp"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.wp-efs.id
    }
  }
}

resource "aws_ecs_service" "wp-ecs-service" {
  name            = "wp-ecs-service"
  cluster         = aws_ecs_cluster.wp-ecs.id
  task_definition = aws_ecs_task_definition.service.id
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.wp-tg.id
    container_name   = "wp"
    container_port   = "80"
  }

  network_configuration {
    subnets = ["${one(aws_subnet.ecs-01[*].id)}", "${one(aws_subnet.ecs-02[*].id)}"
    ]
    security_groups = ["${one(aws_security_group.ecs-sg[*].id)}"
    ]
  }
}