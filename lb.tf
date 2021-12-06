resource "aws_lb" "alb" {
  name               = "test-alb"
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.lb-sg}"
  ]

  subnets = ["${aws_subnet.lb-01.id}", "${aws_subnet.lb-02.id}"]
}

resource "aws_lb_listener" "http-port" {
  load_balancer_arn = aws_lb.alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

