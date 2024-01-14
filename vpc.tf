data "http" "what_is_my_ip" {
  url = "http://ifconfig.co/ip"
}

# Create VPC
resource "aws_vpc" "tf-m-vpc" {
  cidr_block = "10.0.0.0/16"
}

# Attach an inetrnet gateway to the VPC 
resource "aws_internet_gateway" "tf-m-igw" {
  vpc_id = aws_vpc.tf-m-vpc.id
}

# Create subnet 1 in availability zone 1a
resource "aws_subnet" "tf-mike-subnet-1" {
    vpc_id = aws_vpc.tf-m-vpc.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
}

# Create subnet 2 in availability zone 1b
resource "aws_subnet" "tf-mike-subnet-2" {
    vpc_id = aws_vpc.tf-m-vpc.id
    availability_zone = "ap-south-1b"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
}

# Create a public route table by adding a route to the internet gateway
resource "aws_route_table" "tf-mike-public-rt" {
  vpc_id = aws_vpc.tf-m-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
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

# Create security group rules for the instances
resource "aws_security_group" "tf-mike-sg" {
    name        = "tf-ec2-mike-sg-tf"
    description = "Allow HTTP, SSH to INSTANCES"
    vpc_id      = aws_vpc.tf-m-vpc.id

    ingress {
        description = "HTTP ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH ingress"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Target Group listeners"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create security group for the load balancers
resource "aws_security_group" "tf-mike-sg-lb" {
    name        = "tf-mike-sg-lb"
    description = "Allow HTTP"
    vpc_id      = aws_vpc.tf-m-vpc.id

    ingress {
        description = "HTTP ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Attach Application load balancer to VPC
resource "aws_lb" "tf-mike-alb" {
  name               = "tf-mike-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf-mike-sg-lb.id]
  subnets            = [aws_subnet.tf-mike-subnet-1.id, aws_subnet.tf-mike-subnet-2.id]
}

#Create load balancer target group
resource "aws_lb_target_group" "tf-mike-tg" {
  name              = "tf-mike-tg"
  port              = 3000
  protocol          = "HTTP"
  vpc_id            = aws_vpc.tf-m-vpc.id
  health_check {
    enabled         = true
    healthy_threshold = 3
    interval        = 10
    matcher         = 200
    protocol        = "HTTP"
    timeout         = 3
    unhealthy_threshold = 2
  }
}

#Register target group 
resource "aws_lb_target_group_attachment" "attach-tg-ec2-1" {
    target_group_arn = aws_lb_target_group.tf-mike-tg.arn
    target_id        = aws_instance.tf-mike-ec2-1.id
    port             = 3000
}

resource "aws_lb_target_group_attachment" "attach-tg-ec2-2" {
    target_group_arn = aws_lb_target_group.tf-mike-tg.arn
    target_id        = aws_instance.tf-mike-ec2-2.id
    port             = 3000
}

#Create listerner and mount to target group
resource "aws_lb_listener" "tf-mike-alb-lst" {
  load_balancer_arn = aws_lb.tf-mike-alb.arn
  port              =  80
  protocol          =  "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-mike-tg.arn
  }
}

#Output Load balancer dns
output "alb_dns_name" {
  value = aws_lb.tf-mike-alb.dns_name
}
