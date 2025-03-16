output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.tgw.id 
}

output "transit_gateway_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
}