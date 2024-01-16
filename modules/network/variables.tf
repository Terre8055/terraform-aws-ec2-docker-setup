
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
