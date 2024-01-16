# Attach Application load balancer to VPC
resource "aws_lb" "tf-mike-alb" {
  name               = "tf-mike-alb"
  internal           = false
  load_balancer_type = var.lb_types["alb"]
  security_groups    = [module.network.sg_id]
  subnets            = [module.network.sub1-id, module.network.sub2-id]
}


#Create load balancer target group
resource "aws_lb_target_group" "tf-mike-tg" {
  name              = "tf-mike-tg"
  port              = var.target_group_config["port"]["value"]
  protocol          = var.target_group_config["protocol"]["value"]
  vpc_id            = module.network.vpc_id
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