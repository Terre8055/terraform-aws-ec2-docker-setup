resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for Terramino ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn, aws_sns_topic.this.arn ]
  ok_actions          = [aws_sns_topic.this.arn]
  insufficient_data_actions = [aws_sns_topic.this.arn]
  alarm_name          = "tf-mike-alarm-${terraform.workspace}"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}