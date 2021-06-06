output "vpc-id" {
  value = aws_vpc.this.id
}

output "vpc-cidr" {
  value = aws_vpc.this.cidr_block
}

output "igw-id" {
  value = aws_internet_gateway.this.id
}

output "ngw-id" {
  value = aws_nat_gateway.lambda_test_ngw.id
}

output "instance-id" {
  value = module.ec2.*.id
}

output "arn" {
  value = module.ec2.*.arn
}

output "private_ip" {
  value = module.ec2.*.private_ip
}



