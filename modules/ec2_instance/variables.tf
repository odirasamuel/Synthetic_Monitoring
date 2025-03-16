variable "stack_name" {
  description = "Name of the stack"
  type        = string
}

variable "east_region" {
  description = "AWS region to use"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "user_data_file" {
  description = "Path to user data file for the instance."
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for the instance."
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_id" {
  description = "ID of the subnet to launch the instance in."
  type        = string
}

variable "env" {
  description = "Name of the environment"
  type        = string
}

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

variable "ami_id" {
  description = "ID of the AMI to use for the instance."
  type        = string
}

variable "key_pair_public_key" {
  description = "Public key for the key pair."
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