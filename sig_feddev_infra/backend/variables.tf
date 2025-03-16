variable "stack_name" {
  description = "Name of the stack"
  type        = string
  default = "sig"
}

variable "profile" {
  description = "AWS profile to use"
  type        = string
  default = "feddev"
}

variable "region" {
  description = "AWS region to use"
  type        = string
  default = "us-gov-west-1"
}

variable "env" {
  description = "Name of the environment"
  type        = string
  default = "feddev"
}