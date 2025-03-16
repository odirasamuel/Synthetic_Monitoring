resource "aws_lb" "sig_lb" {
  name = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-alb"
  load_balancer_type = "application"
  internal = false
  security_groups = var.security_groups
  subnets = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-alb"
    Environment = terraform.workspace
  } 
}

resource "aws_lb_target_group" "sig_lb_tg" {
  name = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-tg"
  port = var.port
  protocol = "TCP"
  vpc_id = var.vpc_id

  health_check {
    port = var.health_check_port
    protocol = "TCP"
  }

  tags = {
    Name = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-tg"
    Environment = terraform.workspace
  }
  
}

resource "aws_lb_listener" "sig_lb_listener" {
  load_balancer_arn = aws_lb.sig_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.sig_lb_tg.arn
  }
  
}