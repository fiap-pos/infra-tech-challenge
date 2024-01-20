locals {
  producao_queue_name = "fila-producao"
}


# ---- Producao Queue ----

# Create Producao SQS dlq Queue
resource "aws_sqs_queue" "producao-dlq-queue" {
  name = "${local.producao_queue_name}-dlq"
  tags = {
    Name = "${local.producao_queue_name}-dlq"
    application = var.producao_application_tag_name
  }
}

# Create Producao SQS Queue
resource "aws_sqs_queue" "producao-queue" {
  name = local.producao_queue_name
  tags = {
    Name = local.producao_queue_name
    application = var.producao_application_tag_name
  }
}

# Create Redrive Producao Queue policy
resource "aws_sqs_queue_redrive_allow_policy" "producao-queue-redrive-policy" {
  queue_url = aws_sqs_queue.producao-queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.producao-dlq-queue.arn]
  })
  
}