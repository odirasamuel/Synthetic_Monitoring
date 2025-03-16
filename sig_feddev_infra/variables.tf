variable "stack_name" {
  description = "Name of the stack"
  type        = string
}

variable "env" {
  description = "Name of the environment"
  type        = string
}

# variable "cidr_block" {
#   description = "CIDR block for the VPC"
#   type        = string
# }

variable "public_subnets_count" {
  description = "Number of public subnets"
  type        = number
}

variable "private_subnets_count" {
  description = "Number of private subnets"
  type        = number
}

# variable "public_subnets_cidr" {
#   description = "CIDR block for public subnets"
#   type        = list(string)
# }

# variable "private_subnets_cidr" {
#   description = "CIDR block for private subnets"
#   type        = list(string)
# }

variable "nat_gateway_count" {
  description = "Number of NAT gateways"
  type        = number
}

# variable "availability_zones" {
#   description = "List of availability zones"
#   type        = list(string)
# }

variable "east_region" {
  description = "AWS region to use"
  type        = string
  default = "us-gov-east-1"
}

variable "west_region" {
  description = "AWS region to use"
  type        = string
  default = "us-gov-west-1"
}

variable "elastic_ips" {
  description = "Number of Elastic IPs"
  type        = number
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "aws_region" {
  description = "AWS region to use"
  type        = string

  validation {
    condition     = var.aws_region == "us-gov-east-1" || var.aws_region == "us-gov-west-1"
    error_message = "aws_region must be one of: us-gov-east-1 or us-gov-west-1."
  }
}

# variable "stack_tool" {
#   description = "SIG tools"
#   type        = string
# }

variable "ingress_rules" {
  description = "List of ingress rule objects."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rule objects."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

variable "instance_private_ip" {
  description = "Private IP address of the source instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

# variable "user_data_file" {
#   description = "Path to user data file for the instance."
#   type        = string
# }

variable "stack_tool" {
  description = "Name of the stack tool"
  type        = string
}

variable "ebs_volume_type" {
  description = "Type of EBS volume"
  type        = string
}

variable "ebs_volume_size" {
  description = "Size of EBS volume"
  type        = number
}

# This should be supplied directly in the module declaration and not via the .tfvars file
variable "east_region" {
  description = "AWS region to use"
  type        = string
}

variable "source_ami_id" {
  description = "Source AMI ID."
  type        = string
}

variable "source_region" {
  description = "AWS Region where the AMI resides."
  type        = string

  validation {
    condition     = var.source_region == "us-gov-east-1" || var.source_region == "us-gov-west-1"
    error_message = "aws_region must be one of: us-gov-east-1 or us-gov-west-1."
  }
}

# variable "ami_id" {
#   description = "ID of the AMI to use for the instance."
#   type        = string
# }

# variable "key_name" {
#   description = "Name of the key pair to use for the instance."
#   type        = string
# }

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
}

# variable "launch_template_id" {
#   description = "ID of the launch template"
#   type        = string
# }

# variable "launch_template_version" {
#   description = "Version of the launch template"
#   type        = number
# }

# variable "target_group_arns" {
#   description = "List of target group ARNs"
#   type        = list(string)
# }

# variable "health_check_type" {
#   description = "Type of health check"
#   type        = string
# }

# variable "health_check_grace_period" {
#   description = "Health check grace period"
#   type        = number
# }

# variable "termination_policies" {
#   description = "List of termination policies"
#   type        = list(string)
# }

variable "peer_region" {
  description = "Region of the second Transit Gateway for peering"
  type        = string

  validation {
    condition     = var.aws_region == "us-gov-east-1" || var.aws_region == "us-gov-west-1"
    error_message = "aws_region must be one of: us-gov-east-1 or us-gov-west-1."
  }
}

variable "destination_cidr_block" {
  description = "CIDR block for the destination route, most times it is the other region's VPC CIDR block"
  type        = string
}