# Create subnet 1 in availability zone 1a
resource "aws_subnet" "tf-mike-subnet-1" {
    vpc_id = aws_vpc.tf-m-vpc.id
    availability_zone = var.az_zones[0]
    cidr_block = var.public_subnet_cidr_blocks[0]
    map_public_ip_on_launch = true
}

# Create subnet 2 in availability zone 1b
resource "aws_subnet" "tf-mike-subnet-2" {
    vpc_id = aws_vpc.tf-m-vpc.id
    availability_zone = var.az_zones[1]
    cidr_block = var.public_subnet_cidr_blocks[1]
    map_public_ip_on_launch = true
}
