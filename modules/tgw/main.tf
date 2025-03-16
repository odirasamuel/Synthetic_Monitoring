# Using Transit Gateway as a VPC Peering Hub
resource "aws_ec2_transit_gateway" "tgw" {
  description = "TGW for VPC peering"

  tags = {
    Name = "${var.stack_name}-${var.env}-${var.aws_region}-tgw"
    Environment = terraform.workspace
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc_id

  tags = {
    Name = "${var.stack_name}-${var.env}-${var.aws_region}-tgw-attachment"
    Environment = terraform.workspace
  }
}