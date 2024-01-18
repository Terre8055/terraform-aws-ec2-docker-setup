# Create a public route table by adding a route to the internet gateway
resource "aws_route_table" "this" {
  vpc_id          = aws_vpc.tf-m-vpc.id

  route {
    cidr_block    = var.cidr_all
    gateway_id    = aws_internet_gateway.tf-m-igw.id
  }
}

# Associate the route table to the subnet
resource "aws_route_table_association" "this" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this.id
}
