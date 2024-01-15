data "http" "what_is_my_ip" {
  url = "http://ifconfig.co/ip"
}

# Create VPC
resource "aws_vpc" "tf-m-vpc" {
  cidr_block = var.vpc_cidr_block
}

# Attach an inetrnet gateway to the VPC 
resource "aws_internet_gateway" "tf-m-igw" {
  vpc_id = aws_vpc.tf-m-vpc.id
}

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

# Create security group rules for the instances
resource "aws_security_group" "tf-mike-sg" {
    name        = "tf-ec2-mike-sg-tf"
    description = "Allow HTTP, SSH to INSTANCES"
    vpc_id      = aws_vpc.tf-m-vpc.id

    ingress {
        description = var.security_group_default["HTTP"]["description"]
        from_port   = var.security_group_default["HTTP"]["from_port"]
        to_port     = var.security_group_default["HTTP"]["to_port"]
        protocol    = var.security_group_default["HTTP"]["protocol"]
        cidr_blocks = var.security_group_default["HTTP"]["cidr_blocks"]
    }

    ingress {
        description = var.security_group_default["SSH"]["description"]
        from_port   = var.security_group_default["SSH"]["from_port"]
        to_port     = var.security_group_default["SSH"]["to_port"]
        protocol    = var.security_group_default["SSH"]["protocol"]
        cidr_blocks = var.security_group_default["SSH"]["cidr_blocks"]
    }

    ingress {
        description = var.security_group_default["TG"]["description"]
        from_port   = var.security_group_default["TG"]["from_port"]
        to_port     = var.security_group_default["TG"]["to_port"]
        protocol    = var.security_group_default["TG"]["protocol"]
        cidr_blocks = var.security_group_default["TG"]["cidr_blocks"]
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
        description = var.security_group_default["ALB"]["description"]
        from_port   = var.security_group_default["ALB"]["from_port"]
        to_port     = var.security_group_default["ALB"]["to_port"]
        protocol    = var.security_group_default["ALB"]["protocol"]
        cidr_blocks = var.security_group_default["ALB"]["cidr_blocks"]
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
  load_balancer_type = var.lb_types["alb"]
  security_groups    = [aws_security_group.tf-mike-sg-lb.id]
  subnets            = [aws_subnet.tf-mike-subnet-1.id, aws_subnet.tf-mike-subnet-2.id]
}

#Create load balancer target group
resource "aws_lb_target_group" "tf-mike-tg" {
  name              = "tf-mike-tg"
  port              = var.target_group_config["port"]["value"]
  protocol          = var.target_group_config["protocol"]["value"]
  vpc_id            = aws_vpc.tf-m-vpc.id
  health_check {
    enabled         = var.target_group_config["health_check"]["enabled"]
    healthy_threshold = var.target_group_config["health_check"]["healthy_threshold"]
    interval        = var.target_group_config["health_check"]["interval"]
    matcher         = var.target_group_config["health_check"]["matcher"]
    protocol          = var.target_group_config["protocol"]["value"]
    timeout         = var.target_group_config["health_check"]["timeout"]
    unhealthy_threshold = var.target_group_config["health_check"]["unhealthy_threshold"]
  }
}

#Register target group 
resource "aws_lb_target_group_attachment" "attach-tg-ec2-1" {
    target_group_arn = aws_lb_target_group.tf-mike-tg.arn
    target_id        = aws_instance.tf-mike-ec2-1.id
    port             = var.target_group_port
}

resource "aws_lb_target_group_attachment" "attach-tg-ec2-2" {
    target_group_arn = aws_lb_target_group.tf-mike-tg.arn
    target_id        = aws_instance.tf-mike-ec2-2.id
    port             = var.target_group_port
}

#Create listerner and mount to target group
resource "aws_lb_listener" "tf-mike-alb-lst" {
  load_balancer_arn = aws_lb.tf-mike-alb.arn
  port              =  var.load_balancer_listener["port"]
  protocol          =  var.load_balancer_listener["protocol"]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-mike-tg.arn
  }
}

#Output Load balancer dns
output "alb_dns_name" {
  value = aws_lb.tf-mike-alb.dns_name
}
