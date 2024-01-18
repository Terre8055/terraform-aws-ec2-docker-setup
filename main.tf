module "network" {
  source = "./modules/network"
  security_group_default    = var.security_group_default
  az_zones                  = var.az_zones
  vpc_cidr_block            = var.vpc_cidr_block
  cidr_all                  = var.cidr_all
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  subnet_count              = var.subnet_count
}


module "compute" {
  source                  = "./modules/compute"
  instance_types          = var.instance_types
  lb_types                = var.lb_types
  load_balancer_listener  = var.load_balancer_listener
  target_group_port       = var.target_group_port
  target_group_config     = var.target_group_config
  associate_public_ip_address = var.associate_public_ip_address
  instance_count          = var.instance_count
  asg_min                 = var.asg_min
  asg_max                 = var.asg_max
  asg_ok                  = var.asg_ok
  vpc_id                  = module.network.vpc_id
  subnet_ids              = module.network.sub-id
  sg_ec2                  = module.network.sg_id_ec2
  sg_lb                   = module.network.sg_id_lb
  lb_subnets              = module.network.sub-id
  az                      = module.network.az_zones 
}