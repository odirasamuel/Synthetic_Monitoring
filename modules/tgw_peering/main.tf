resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  transit_gateway_id = var.transit_gateway_id
  peer_transit_gateway_id = var.peer_transit_gateway_id
  peer_region = var.peer_region

  tags = {
    Name = "${var.stack_name}-${var.env}-${var.aws_region}-tgw-peering"
    Environment = terraform.workspace
  }
}