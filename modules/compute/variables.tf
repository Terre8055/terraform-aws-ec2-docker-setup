variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ec2_name" {
  type = string
  default = "ec2-mike"
}

#Default tags for resources
variable "tags"{
    description     = "Default tags"
    type            = map(string)
    default         = {
        owner       = "michael.appiah.dankwah"
        expiration_date = "03-03-2024"
        bootcamp    = "ghana2"
    }
}

#Cidr for vpc
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

#Available cidr blocks for public subnets
variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

#Availability zones for mumbai(ap-south-1)
variable "az_zones" {
  description = "Availability zones in ap-south-1 region"
  type        = list(string)
  default     = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

#Allow from everywhere cidr
variable "cidr_all" {
    description = "Allow from everywhere"
    type = string
    default = "0.0.0.0/0"
}


#Security group rules for resources
variable "security_group_default"{
    description     = "Security group for SSH, http, Target Group"
    type            = map(any)
    default         = {
        HTTP = {
            description = "HTTP ingress"
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        SSH = {
            description = "SSH ingress"
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        TG = {
            description = "Containers"
            from_port   = 3000
            to_port     = 3000
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        ALB = {
            description = "LB ingress"
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

variable "lb_types" {
  description = "Load Balancer types"
  type        = map(string)
    default = {
        alb = "application"
        nlb = "network"
        clb = "classic"
    }
}

variable "target_group_config" {
  description = "Target group configurations"
  type        = map(map(any))
  default = {
        port = {
            value = 3000
        }
        protocol = {
            value = "HTTP"
        }
        health_check = {
            enabled = true
            healthy_threshold = 3
            interval = 10
            matcher = 200
            protocol = "HTTP"
            timeout = 3
            unhealthy_threshold = 2
        }
    }
}

variable "target_group_port" {
  description = "Specify Port for target group"
  type = number
  default = 3000
}


variable "load_balancer_listener" {
  description = "Specify Port and protocol for load balancer listener"
  type = map(any)
  default = {
      port              =  80
      protocol          =  "HTTP"
  }
}

variable "instance_types" {
    description = "Instance types to use"
    type = list(string)
    default     = ["t2.micro", "t3a.micro"]
}

variable "associate_public_ip_address" {
    description = "Associate public IPs"
    type = bool
    default = true
  
}