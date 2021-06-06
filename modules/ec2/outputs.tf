output "id" {
  value = aws_instance.this.*.id
}

output "arn" {
  value = aws_instance.this.*.arn
}

output "private_ip" {
  value = aws_instance.this.*.private_ip
}

output "public_ip" {
  value = aws_instance.this.*.public_ip
}

output "availability_zone" {
  value = aws_instance.this.*.availability_zone
}

output "subnet_id" {
  value = aws_instance.this.*.subnet_id
}

output "tags" {
  value = aws_instance.this.*.tags
}