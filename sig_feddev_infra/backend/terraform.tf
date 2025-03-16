terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = { version = "~> 4.9" }
  }
  # backend "s3" {
  #   bucket         = ""
  #   dynamodb_table = ""
  #   key            = ""
  #   encrypt        = true
  #   profile        = ""
  #   region         = "us-east-2"
  # }
}