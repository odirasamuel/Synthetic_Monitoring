variable "env" {
  description = "Name of the environment"
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

variable "stack_name" {
  description = "Name of the stack"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "stack_tool" {
  description = "SIG tools"
  type        = string
}

variable "port" {
  description = "Port to listen on"
  type        = number
}

variable "health_check_port" {
  description = "Port to use for health checks"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}