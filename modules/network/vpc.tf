

# Create VPC
resource "aws_vpc" "tf-m-vpc" {
  cidr_block = var.vpc_cidr_block
}

# Attach an inetrnet gateway to the VPC 
resource "aws_internet_gateway" "tf-m-igw" {
  vpc_id = aws_vpc.tf-m-vpc.id
}

