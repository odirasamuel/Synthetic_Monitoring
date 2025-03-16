locals {
  timestamp = formatdate("YYYYMMDD-HHMMSS", timestamp())
  unique_id = uuid()
  ami_name   = "${var.stack_name}-${var.env}-${var.aws_region}-${local.timestamp}-${substr(local.unique_id, 0, 8)}"
}

resource "aws_ami_copy" "copy_ami" {
  name = local.ami_name
  source_ami_id = var.source_ami_id
  source_ami_region = var.source_region

  tags = {
    "Name" = local.ami_name
    "Environment" = terraform.workspace
  }
  
}