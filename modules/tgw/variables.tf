variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

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