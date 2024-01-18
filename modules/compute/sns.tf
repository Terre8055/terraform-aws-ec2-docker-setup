resource "aws_sns_topic" "this" {
  name            = "tf-mike-sns-${terraform.workspace}"
}


resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name = "terraform-queue-deadletter"
}


resource "aws_sqs_queue" "this" {
  name      = "tf-mike-sqs-${terraform.workspace}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "sqs:SendMessage",
        Resource = "*",
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.this.arn,
          },
        },
      },
    ],
  })
}
