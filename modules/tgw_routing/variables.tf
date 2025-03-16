variable "destination_cidr_block" {
  description = "CIDR block for the destination route, most times it is the other region's VPC CIDR block"
  type        = string
}

variable "transit_gateway_peering_attachment_id" {
  description = "ID of the Transit Gateway peering attachment"
  type        = string
}

variable "destination_vpc_id" {
  description = "ID of the destination VPC"
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

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  type        = string
}

variable "transit_gateway_vpc_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment"
  type        = string
}