resource "aws_autoscaling_group" "asg" {
  name = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-asg"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity

  launch_template {
    id = var.launch_template_id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnet_ids
  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  termination_policies = var.termination_policies

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = terraform.workspace
    propagate_at_launch = true
  }

}