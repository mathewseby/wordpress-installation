//resource "aws_lb" "alb" {
//  count              = var.install_type == "ecs" ? 1 : 0
//  name               = "ecs-alb"
//  load_balancer_type = "application"
//  security_groups    = ["${one(aws_security_group.lb-sg[*].id)}"]
//
//
//  subnets = ["${one(aws_subnet.lb-01[*].id)}", "${one(aws_subnet.lb-02[*].id)}"]
//}
//
//resource "aws_lb_listener" "http-port" {
//  count             = var.install_type == "ecs" ? 1 : 0
//  load_balancer_arn = one(aws_lb.alb[*].id)
//  port              = "80"
//  protocol          = "HTTP"
//
//  default_action {
//    type             = "forward"
//    target_group_arn = aws_lb_target_group.wp-tg.id
//
//    redirect {
//      port        = "443"
//      protocol    = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//}
//
//resource "aws_lb_target_group" "wp-tg" {
//  count       = var.install_type == "ecs" ? 1 : 0
//  name        = "wp-tg"
//  port        = 80
//  protocol    = "HTTP"
//  target_type = "ip"
//  vpc_id      = aws_vpc.vpc.id
//}