resource "aws_launch_configuration" "this" {
  name                        = "tf-mike-launch-${terraform.workspace}"
  image_id                    = "ami-0d3f444bc76de0a79"
  instance_type               = var.instance_types
  user_data                   = file("${path.module}/run-docker.sh")
  security_groups             = [var.sg_ec2]
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = aws_key_pair.key-pair.key_name
  
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  name                        = "tf-mike-asg-${terraform.workspace}"
  min_size                    = var.asg_min
  max_size                    = var.asg_max
  desired_capacity            = var.asg_ok
  launch_configuration        = aws_launch_configuration.this.name
  vpc_zone_identifier         = var.subnet_ids
  health_check_type           = "ELB"
  target_group_arns           = [aws_lb_target_group.tg.arn] 
  
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "tf-asg-mike-${terraform.workspace}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "tf-mike-scale-down-${terraform.workspace}"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}