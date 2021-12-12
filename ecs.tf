resource "aws_ecs_cluster" "wp-ecs" {
  name = "wp-ecs"
}

resource "aws_ecr_repository" "wp-ecr" {
  name = "wp-ecr"

}

#resource "aws_ecs_task_definition" "wp-ecs-td" {
#  container_definitions = jsondecode([
#    {
#      name = "wp"
#      image =
#    }
#  ])
#  family = ""
#}