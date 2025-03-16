locals {
  timestamp = formatdate("YYYYMMDD-HHMMSS", timestamp())
  unique_id = uuid()
  ami_name   = "${var.stack_name}-${var.env}-${var.aws_region}-${local.timestamp}-${substr(local.unique_id, 0, 8)}"
}

resource "aws_ami_from_instance" "ami" {
  name = local.ami_name
  source_instance_id = var.source_instance_id
  snapshot_without_reboot = true
  tags = {
    "Name" = local.ami_name
    "Environment" = terraform.workspace
  }
}