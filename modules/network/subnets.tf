# Create 2 subnets in availability zone 1a and 1b
resource "aws_subnet" "this" {
    count                   = var.subnet_count
    vpc_id                  = aws_vpc.tf-m-vpc.id
    availability_zone       = var.az_zones[count.index]
    cidr_block              = var.public_subnet_cidr_blocks[count.index]
    map_public_ip_on_launch = true
}