output "ec2-1-public-ip" {
  value = aws_instance.tf-mike-ec2-1.public_ip
}

output "ec2-1-public-dns" {
  value = aws_instance.tf-mike-ec2-1.public_dns
}

output "ec2-2-public-ip" {
  value = aws_instance.tf-mike-ec2-2.public_ip
}

output "ec2-2-public-dns" {
  value = aws_instance.tf-mike-ec2-2.public_dns
}

output "alb_dns_name" {
  value = aws_lb.tf-mike-alb.dns_name
}