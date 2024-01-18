data "http" "what_is_my_ip" {
  url = "http://ifconfig.co/ip"
}

# Create security group rules for the instances
resource "aws_security_group" "sg-inst" {
    name            = "tf-ec2-mike-sg-tf-${terraform.workspace}"
    description     = "Allow HTTP, SSH to INSTANCES"
    vpc_id          = aws_vpc.tf-m-vpc.id

    ingress {
        description = var.security_group_default["HTTP"]["description"]
        from_port   = var.security_group_default["HTTP"]["from_port"]
        to_port     = var.security_group_default["HTTP"]["to_port"]
        protocol    = var.security_group_default["HTTP"]["protocol"]
        security_groups = [aws_security_group.sg-lb.id]
    }

    ingress {
        description = var.security_group_default["SSH"]["description"]
        from_port   = var.security_group_default["SSH"]["from_port"]
        to_port     = var.security_group_default["SSH"]["to_port"]
        protocol    = var.security_group_default["SSH"]["protocol"]
        cidr_blocks = ["${chomp(data.http.what_is_my_ip.response_body)}/32"]
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
resource "aws_security_group" "sg-lb" {
    name        = "tf-mike-sg-lb-${terraform.workspace}"
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