output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[*].id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}