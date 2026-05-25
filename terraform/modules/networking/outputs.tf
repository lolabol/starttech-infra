output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = aws_subnet.private[*].id
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value = aws_security_group.alb.id
}

output "ec2_sg_id" {
  description = "EC2 security group ID"
  value = aws_security_group.ec2.id
}
