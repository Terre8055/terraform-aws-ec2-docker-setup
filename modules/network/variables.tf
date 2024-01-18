#Cidr for vpc
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

#Available cidr blocks for public subnets
variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)

}

#Availability zones for mumbai(ap-south-1)
variable "az_zones" {
  description = "Availability zones in ap-south-1 region"
  type        = list(string)
}

#Allow from everywhere cidr
variable "cidr_all" {
    description = "Allow from everywhere"
    type = string
}

#Security group rules for resources
variable "security_group_default"{
    description     = "Security group for SSH, http, Target Group"
    type            = map(any)
}

variable "subnet_count" {
  description   = "Number of subnets"
  type          = number   
}
