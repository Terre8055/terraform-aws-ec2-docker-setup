variable "lb_types" {
  description = "Load Balancer types"
  type        = map(string)
}

variable "target_group_config" {
  description = "Target group configurations"
  type        = map(map(any))
}

variable "target_group_port" {
  description = "Specify Port for target group"
  type        = number
}


variable "load_balancer_listener" {
  description = "Specify Port and protocol for load balancer listener"
  type        = map(any)
}


variable "instance_count" {
  description   = "NUmber of instances to provision"
  type          = number
}

variable "instance_types" {
    description = "Instance types to use"
    type        = string
}

variable "associate_public_ip_address" {
    description = "Associate public IPs"
    type        = bool
}

variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}


variable "lb_subnets" {
  description = "Subnet IDs for ALB"
  type        = list(string)
}

variable "sg_ec2" {
  description = "Security Group EC2s"
  type        = string
}

variable "sg_lb" {
  description = "Security Group ALB"
  type        = string
}

variable "az" {
  description = "Availabitlity zones"
  type        = list(string)
}

variable "asg_min" {
  description = "Minimum number of instances in asg"
  type        = number 
} 

variable "asg_max" {
  description = "Max number of instances in asg"
  type        = number 
} 

variable "asg_ok" {
  description = "Desired number of instances in asg"
  type        = number 
} 