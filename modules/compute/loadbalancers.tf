# Attach Application load balancer to VPC
resource "aws_lb" "alb" {
  name               = "tf-mike-alb-${terraform.workspace}"
  internal           = false
  load_balancer_type = var.lb_types["alb"]
  security_groups    = [var.sg_lb]
  subnets            = [for id in var.lb_subnets : id]
}


#Create load balancer target group
resource "aws_lb_target_group" "tg" {
  name              = "tf-mike-tg-${terraform.workspace}"
  port              = var.target_group_config["port"]["value"]
  protocol          = var.target_group_config["protocol"]["value"]
  vpc_id            = var.vpc_id
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

#Create listerner and mount to target group
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port              =  var.load_balancer_listener["port"]
  protocol          =  var.load_balancer_listener["protocol"]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}