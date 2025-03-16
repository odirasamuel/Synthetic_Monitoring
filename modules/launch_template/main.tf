resource "aws_launch_template" "launch_template" {
  name_prefix = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-launch-template"
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.security_group_ids
  user_data = base64encode(var.user_data_file)

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.ebs_volume_size
      volume_type = var.ebs_volume_type
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = var.security_group_ids
    subnet_id = var.subnet_id
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-instance"
      Environment = terraform.workspace
    }
  }  
}