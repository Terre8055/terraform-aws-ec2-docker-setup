# Create ssh rsa key pair to connect to instances

resource "aws_key_pair" "tf-key-pair-mike" {
key_name = "tf-key-pair-mike"
public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}

resource "local_file" "tf-key-mike" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}

# Provision ec2 instance 1
resource "aws_instance" "tf-mike-ec2-1" {
  ami               = "ami-0d3f444bc76de0a79"
  instance_type     = var.instance_types[1]
  subnet_id         = aws_subnet.tf-mike-subnet-1.id
  vpc_security_group_ids = [aws_security_group.tf-mike-sg.id]
  associate_public_ip_address = var.associate_public_ip_address
  user_data = file("${path.module}/run-docker.sh")
  key_name                   = "tf-key-pair-mike"
  tags = {
    Name = "tf-mike-ec2-1" 
  }
}

# Provision ec2 instance 2
resource "aws_instance" "tf-mike-ec2-2" {
  ami               = "ami-0d3f444bc76de0a79"
  instance_type     = var.instance_types[1]
  subnet_id         = aws_subnet.tf-mike-subnet-2.id
  vpc_security_group_ids = [aws_security_group.tf-mike-sg.id]
  associate_public_ip_address = var.associate_public_ip_address
  user_data = file("${path.module}/run-docker.sh")
  key_name                   = "tf-key-pair-mike" 
  tags = {
    Name = "tf-mike-ec2-2" 
  }
}