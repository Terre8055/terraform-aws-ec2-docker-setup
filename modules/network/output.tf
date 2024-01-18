output "sub-id" {
  value = aws_subnet.this[*].id
}


output "sg_id_ec2" {
  value = aws_security_group.sg-inst.id
}

output "sg_id_lb" {
  value = aws_security_group.sg-lb.id
}


output "vpc_id" {
  value = aws_vpc.tf-m-vpc.id
}

output "az_zones" {
  value = ["ap-south-1a", "ap-south-1b"]
}