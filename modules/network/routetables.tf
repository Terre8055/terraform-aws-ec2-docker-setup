# Create a public route table by adding a route to the internet gateway
resource "aws_route_table" "tf-mike-public-rt" {
  vpc_id = aws_vpc.tf-m-vpc.id

  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.tf-m-igw.id
  }
}

# Associate the route table to the subnet
resource "aws_route_table_association" "tf-mike-subnet-1-association" {
  subnet_id      = aws_subnet.tf-mike-subnet-1.id
  route_table_id = aws_route_table.tf-mike-public-rt.id
}

# Associate the route table to the subnet
resource "aws_route_table_association" "tf-mike-subnet-2-association" {
  subnet_id      = aws_subnet.tf-mike-subnet-2.id
  route_table_id = aws_route_table.tf-mike-public-rt.id
}