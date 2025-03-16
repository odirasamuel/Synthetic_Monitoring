resource "aws_key_pair" "replicate_key" {
  count = var.east_region == "us-gov-west-1" ? 0 : 1
  key_name   = var.key_name
  public_key = var.key_pair_public_key
}

resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = length(aws_key_pair.replicate_key) == 1 ? "${aws_key_pair.replicate_key[0].key_name}" : var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  user_data              = var.user_data_file

  tags = {
    Name        = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-instance"
    Environment = terraform.workspace
  }
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = aws_instance.instance.availability_zone
  type = var.ebs_volume_type
  size = var.ebs_volume_size

  tags = {
    Name        = "${var.stack_name}-${var.env}-${var.aws_region}-${var.stack_tool}-instance"
    Environment = terraform.workspace
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdf"
  instance_id = aws_instance.instance.id
  volume_id = aws_ebs_volume.ebs.id
}