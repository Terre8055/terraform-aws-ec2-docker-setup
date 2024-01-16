output "sub1-id" {
  value = aws_subnet.tf-mike-subnet-1.id
  sensitive = true
}

output "sub2-id" {
  value = aws_subnet.tf-mike-subnet-2.id
  sensitive = true
}

output "sg_id" {
  value = aws_security_group.tf-mike-sg.id
}


output "vpc_id" {
  value = aws_vpc.tf-m-vpc.id
}