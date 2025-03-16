resource "aws_ec2_transit_gateway_route_table" "tgw_route_table" {
  transit_gateway_id = var.transit_gateway_id

  tags = {
    Name = "${var.stack_name}-${var.env}-${var.aws_region}-tgw-route-table"
    Environment = terraform.workspace
  }
  
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_route_table_association" {
  transit_gateway_attachment_id = var.transit_gateway_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_route_table.id
}

resource "aws_ec2_transit_gateway_route" "tgw_route" {
  destination_cidr_block = var.destination_cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_route_table.id
  transit_gateway_attachment_id = var.transit_gateway_peering_attachment_id
}

resource "aws_route_table" "private_rt_to_tgw_attachment" {
  vpc_id = var.destination_vpc_id

  route {
    cidr_block     = var.destination_cidr_block
    transit_gateway_id = var.transit_gateway_id
  }

  tags = {
    Name        = "${var.stack_name}-${var.env}-${var.aws_region}-private-rt-to-tgw-attachment"
    Environment = terraform.workspace
  }
}