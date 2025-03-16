# To be used if ami_from_instance works as planned
data "aws_instance" "by_private_ip" {
  filter {
    name   = "private-ip-address"
    values = [var.instance_private_ip]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  
  provider = aws.east
}

data "aws_key_pair" "sig_master_key" {
  key_name = "SIG_MASTER_SSH_KEY"
  include_public_key = true

  provider = aws.west
}

module "vpc_east" {
  source = "../../modules/vpc"
  region = var.east_region
  stack_name = var.stack_name
  cidr_block = ""
  private_subnets_count = var.private_subnets_count
  public_subnets_count = var.public_subnets_count
  public_subnets_cidr = ""
  private_subnets_cidr = ""
  nat_gateway_count = var.nat_gateway_count
  availability_zones = ""
  
  providers = {
    aws = aws.east
  }
}

module "vpc_west" {
  source = "../../modules/vpc"
  region = var.west_region
  stack_name = var.stack_name
  cidr_block = ""
  private_subnets_count = var.private_subnets_count
  public_subnets_count = var.public_subnets_count
  public_subnets_cidr = ""
  private_subnets_cidr = ""
  nat_gateway_count = var.nat_gateway_count
  availability_zones = ""
  
  providers = {
    aws = aws.west
  }
}

# ALB Security group for multiple Selenium Hub instances in the west region
module "alb_security_group_west" {
  source = "../../modules/security_groups"
  stack_name = var.stack_name
  aws_region = var.west_region
  stack_tool = "selenium-alb"
  vpc_id = module.vpc_west.vpc_id
  ingress_rules = [
  {
    description      = "Allow HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  },
  {
    description      = "Allow HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
]
  egress_rules = [
  {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
]

  providers = {
    aws = aws.west
  }
}

# The Security Group for the Selenium Hub in the West region
# If ALB is used then traffic should be allowed from ALB security group to the Selenium Hub security group in the west region
module "selenium_hub_security_group_west" {
  source = "../../modules/security_groups"
  stack_name = var.stack_name
  aws_region = var.west_region
  env = var.env
  stack_tool = "selenium"
  vpc_id = module.vpc_west.vpc_id
  ingress_rules = [
  {
    description      = "Allow Selenium Grid port"
    from_port        = 4444
    to_port          = 4444
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = ["${module.alb_security_group_west.selenium_sg_id}"]
  },
  {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  },
  {
    description      = "Selenium Event Bus publish"
    from_port        = 4442
    to_port          = 4442
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = ["${module.alb_security_group_west.selenium_sg_id}"]
  },
  {
    description      = "Selenium Event Bus subscribe"
    from_port        = 4443
    to_port          = 4443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = ["${module.alb_security_group_west.selenium_sg_id}"]
  }
]
  egress_rules = [
  {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
]

  providers = {
    aws = aws.west
  }
}

# The Security Group for the Selenium Nodes in the West region
module "selenium_nodes_security_group_west" {
  source = "../../modules/security_groups"
  stack_name = var.stack_name
  aws_region = var.west_region
  env = var.env
  stack_tool = "selenium"
  vpc_id = module.vpc_west.vpc_id
  ingress_rules = [
  {
    description      = "Selenium Node default port"
    from_port        = 5555
    to_port          = 5555
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  },
  {
    description      = "Selenium Event Bus publish"
    from_port        = 4442
    to_port          = 4442
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  },
  {
    description      = "Selenium Event Bus subscribe"
    from_port        = 4443
    to_port          = 4443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  },
  {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
  egress_rules = [
  {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
]

  providers = {
    aws = aws.west
  }
}

# The Security Group for the Selenium Nodes in the East region
module "selenium_nodes_security_group_east" {
  source = "../../modules/security_groups"
  stack_name = var.stack_name
  env = var.env
  aws_region = var.east_region
  stack_tool = "selenium"
  vpc_id = module.vpc_east.vpc_id
  ingress_rules = [
  {
    description      = "Selenium Node default port"
    from_port        = 5555
    to_port          = 5555
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  },
  {
    description      = "Selenium Event Bus publish"
    from_port        = 4442
    to_port          = 4442
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  },
  {
    description      = "Selenium Event Bus subscribe"
    from_port        = 4443
    to_port          = 4443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  },
  {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups  = []
  }
]
  egress_rules = [
  {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
]

  providers = {
    aws = aws.east
  }
}

# Create an AMI from the source instance in the source region
module "create_ami" {
  source = "../../modules/create_ami"
  env = var.env
  aws_region = var.east_region
  stack_name = var.stack_name
  source_instance_id = data.aws_instance.by_private_ip.id

  providers = {
    aws = aws.east
  }
}

# Copy the AMI from source region to the destination region
module "copy_ami" {
  source = "../../modules/copy_ami"
  stack_name = var.stack_name
  env = var.env
  source_ami_id = module.create_ami.ami_id
  source_region = var.source_region

  providers = {
    aws = aws.west
  }
  
}

# ALB for the Selenium Hub instances in the West region
module "alb_west" {
  source = "../../modules/alb"
  env = var.env
  aws_region = var.west_region
  stack_name = var.stack_name
  security_groups = ["${module.alb_security_group_west.security_group_id}"]
  subnet_ids = ["${module.vpc_west.public_subnets_id[0]}", "${module.vpc_west.private_subnets_id[0]}"]
  stack_tool = "selenium-alb"
  port = 4444
  health_check_port = "4444"
  vpc_id = module.vpc_west.vpc_id

  providers = {
    aws = aws.west
  }
}

# Launch Template for the Selenium Hub instances in the West region
module "launch_template_selenium_hub_west" {
  source = "../../modules/launch_template"
  env = var.env
  aws_region = var.west_region
  stack_name = var.stack_name
  instance_type = var.instance_type
  key_name = module.sig_master_key.key_name
  security_group_ids = ["${module.selenium_hub_security_group_west.security_group_id}"]
  subnet_id = "${module.vpc_west.private_subnets_id[0]}"
  user_data_file = file("../../script/hub.sh")
  ebs_volume_type = var.ebs_volume_type
  ebs_volume_size = var.ebs_volume_size
  ami_id = module.copy_ami.ami_id

  providers = {
    aws = aws.west
  }
}

# ASG for the Selenium Hub instances in the West region
module "asg_selenium_hub_west" {
  source = "../../modules/asg"
  env = var.env
  aws_region = var.west_region
  stack_name = var.stack_name
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  launch_template_id = module.launch_template_selenium_hub_west.launch_template_id
  launch_template_version = module.launch_template_selenium_hub_west.launch_template_version
  subnet_ids = ["${module.vpc_west.private_subnets_id[0]}"]
  target_group_arns = ["${module.alb_west.target_group_arn}"]
  health_check_type = "ELB"
  health_check_grace_period = 300
  termination_policies = ["OldestInstance"]

  providers = {
    aws = aws.west
  }
}

# Launch Template for the Selenium Node instances in the West region
module "launch_template_selenium_node_west" {
  source = "../../modules/launch_template"
  env = var.env
  aws_region = var.west_region
  stack_name = var.stack_name
  instance_type = var.instance_type
  key_name = module.sig_master_key.key_name
  security_group_ids = ["${module.selenium_nodes_security_group_west.security_group_id}"]
  subnet_id = "${module.vpc_west.private_subnets_id[0]}"
  user_data_file = file("../../script/worker.sh")
  ebs_volume_type = var.ebs_volume_type
  ebs_volume_size = var.ebs_volume_size
  ami_id = module.copy_ami.ami_id

  providers = {
    aws = aws.west
  }
}

# ASG for the Selenium Node instances in the West region
module "asg_selenium_node_west" {
  source = "../../modules/asg"
  env = var.env
  aws_region = var.west_region
  stack_name = var.stack_name
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  launch_template_id = module.launch_template_selenium_node_west.launch_template_id
  launch_template_version = module.launch_template_selenium_node_west.launch_template_version
  subnet_ids = ["${module.vpc_west.private_subnets_id[0]}"]
  target_group_arns = ["${module.alb_west.target_group_arn}"]
  health_check_type = "ELB"
  health_check_grace_period = 300
  termination_policies = ["OldestInstance"]

  providers = {
    aws = aws.west
  }
}

# Launch Template for the Selenium Node instances in the East region
module "launch_template_selenium_node_east" {
  source = "../../modules/launch_template"
  env = var.env
  aws_region = var.east_region
  stack_name = var.stack_name
  instance_type = var.instance_type
  key_name = module.sig_master_key.key_name
  security_group_ids = ["${module.selenium_nodes_security_group_east.security_group_id}"]
  subnet_id = "${module.vpc_east.private_subnets_id[0]}"
  user_data_file = file("../../script/worker.sh")
  ebs_volume_type = var.ebs_volume_type
  ebs_volume_size = var.ebs_volume_size
  ami_id = module.create_ami.ami_id

  providers = {
    aws = aws.east
  }
}

# ASG for the Selenium Node instances in the East region
module "asg_selenium_node_east" {
  source = "../../modules/asg"
  env = var.env
  aws_region = var.east_region
  stack_name = var.stack_name
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  launch_template_id = module.launch_template_selenium_node_east.launch_template_id
  launch_template_version = module.launch_template_selenium_node_east.launch_template_version
  subnet_ids = ["${module.vpc_east.private_subnets_id[0]}"]
  target_group_arns = []
  health_check_type = "ELB"
  health_check_grace_period = 300
  termination_policies = ["OldestInstance"]

  providers = {
    aws = aws.east
  }
}

# Target gateway for west region
module "target_gateway_west" {
  source = "../../modules/tgw"
  aws_region = var.west_region
  stack_name = var.stack_name
  vpc_id = module.vpc_west.vpc_id
  subnet_ids = ["${module.vpc_west.public_subnets_id[0]}", "${module.vpc_west.private_subnets_id[0]}"]

  providers = {
    aws = aws.west
  }
}


# Target gateway for east region
module "target_gateway_east" {
  source = "../../modules/tgw"
  aws_region = var.east_region
  stack_name = var.stack_name
  vpc_id = module.vpc_east.vpc_id
  subnet_ids = ["${module.vpc_east.public_subnets_id[0]}", "${module.vpc_east.private_subnets_id[0]}"]

  providers = {
    aws = aws.east
  }
}

# Target gateway peering (Cross Region)
module "tgw_peering" {
  source = "../../modules/tgw_peering"
  aws_region = var.west_region
  stack_name = var.stack_name
  transit_gateway_id = module.target_gateway_west.transit_gateway_id
  peer_transit_gateway_id = module.target_gateway_east.transit_gateway_id
  peer_region = var.east_region

  providers = {
    aws = aws.west
  }
}

# Target gateway routing for west region
module "tgw_routing_west" {
  source = "../../modules/tgw_routing"
  aws_region = var.west_region
  stack_name = var.stack_name
  transit_gateway_id = module.target_gateway_west.transit_gateway_id
  vpc_id = module.vpc_west.vpc_id
  subnet_ids = ["${module.vpc_west.public_subnets_id[0]}", "${module.vpc_west.private_subnets_id[0]}"]
  transit_gateway_vpc_attachment_id = module.target_gateway_west.transit_gateway_vpc_attachment_id
  transit_gateway_peering_attachment_id = module.tgw_peering.transit_gateway_peering_attachment_id
  destination_cidr_block = module.vpc_east.vpc_cidr_block
  destination_vpc_id = module.vpc_east.vpc_id

  providers = {
    aws = aws.west
  }
}

# Target gateway routing for east region
module "tgw_routing_east" {
  source = "../../modules/tgw_routing"
  aws_region = var.east_region
  stack_name = var.stack_name
  transit_gateway_id = module.target_gateway_east.transit_gateway_id
  vpc_id = module.vpc_east.vpc_id
  subnet_ids = ["${module.vpc_east.public_subnets_id[0]}", "${module.vpc_east.private_subnets_id[0]}"]
  transit_gateway_vpc_attachment_id = module.target_gateway_east.transit_gateway_vpc_attachment_id
  transit_gateway_peering_attachment_id = module.tgw_peering.transit_gateway_peering_attachment_id
  destination_cidr_block = module.vpc_west.vpc_cidr_block
  destination_vpc_id = module.vpc_west.vpc_id

  providers = {
    aws = aws.east
  }
}




















# # Selenium hub without ASG
# module "selenium_hub_instance_west" {
#   source = "../../modules/ec2_instance"
#   instance_type = var.instance_type
#   user_data_file = var.user_data_file
#   key_name = module.sig_master_key.key_name
#   security_group_ids = [module.selenium_hub_security_group_west.security_group_id]
#   subnet_id = module.vpc_west.public_subnet_id
#   env = var.env
#   stack_tool = var.stack_tool
#   ebs_volume_type = var.ebs_volume_type
#   ebs_volume_size = var.ebs_volume_size
#   ami_id = module.copy_ami.ami_id
#   key_pair_public_key = module.sig_master_key.public_key
#   aws_region = var.west_region
#   stack_name = var.stack_name
#   east_region = "us-gov-west-1"

#   providers = {
#     aws = aws.west
#   }
# }

# # Selenium node in the west region without ASG
# module "selenium_node_instance_west" {
#   source = "../../modules/ec2_instance"
#   instance_type = var.instance_type
#   user_data_file = var.user_data_file
#   key_name = module.sig_master_key.key_name
#   security_group_ids = [module.selenium_nodes_security_group_west.security_group_id]
#   subnet_id = module.vpc_west.public_subnet_id
#   env = var.env
#   stack_tool = var.stack_tool
#   ebs_volume_type = var.ebs_volume_type
#   ebs_volume_size = var.ebs_volume_size
#   ami_id = module.copy_ami.ami_id
#   key_pair_public_key = module.sig_master_key.public_key
#   aws_region = var.west_region
#   stack_name = var.stack_name
#   east_region = "us-gov-west-1"

#   providers = {
#     aws = aws.west
#   }
  
# }

# # Selenium node in the east region without ASG
# module "selenium_node_instance_east" {
#   source = "../../modules/ec2_instance"
#   instance_type = var.instance_type
#   user_data_file = var.user_data_file
#   key_name = module.sig_master_key.key_name
#   security_group_ids = [module.selenium_nodes_security_group_east.security_group_id]
#   subnet_id = module.vpc_east.public_subnet_id
#   env = var.env
#   stack_tool = var.stack_tool
#   ebs_volume_type = var.ebs_volume_type
#   ebs_volume_size = var.ebs_volume_size
#   ami_id = module.create_ami.ami_id
#   key_pair_public_key = module.sig_master_key.public_key
#   aws_region = var.east_region
#   stack_name = var.stack_name
#   west_region = "us-gov-west-1"

#   providers = {
#     aws = aws.east
#   }
  
# }