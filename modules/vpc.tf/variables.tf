variable "stack_name" {
  description = "Name of the stack"
  type        = string
}

variable "env" {
  description = "Name of the environment"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets_count" {
  description = "Number of public subnets"
  type        = number
}

variable "private_subnets_count" {
  description = "Number of private subnets"
  type        = number
}

variable "public_subnets_cidr" {
  description = "CIDR block for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "CIDR block for private subnets"
  type        = list(string)
}

variable "nat_gateway_count" {
  description = "Number of NAT gateways"
  type        = number
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region to use"
  type        = string

  validation {
    condition     = var.aws_region == "us-gov-east-1" || var.aws_region == "us-gov-west-1"
    error_message = "aws_region must be one of: us-gov-east-1 or us-gov-west-1."
  }
  
}

variable "elastic_ips" {
  description = "Number of Elastic IPs"
  type        = number
}