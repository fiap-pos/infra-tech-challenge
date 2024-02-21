locals {
  producao_queue_name = "fila-producao"
  pagamentos_queue_name = "pagamentos"
  pedidos_queue_name = "pedido-criado"
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

# ---- Pagamentos Queue ----

# Create Pagamentos SQS dlq Queue
resource "aws_sqs_queue" "pagamentos-dlq-queue" {
  name = "${local.pagamentos_queue_name}-dlq"
  tags = {
    Name = "${local.pagamentos_queue_name}-dlq"
    application = var.pagamentos_application_tag_name
  }
}

# Create Pagamentos SQS Queue
resource "aws_sqs_queue" "pagamentos-queue" {
  name = local.pagamentos_queue_name
  tags = {
    Name = local.pagamentos_queue_name
    application = var.pagamentos_application_tag_name
  }
}

# Create Redrive Pagamentos Queue policy
resource "aws_sqs_queue_redrive_allow_policy" "pagamentos-queue-redrive-policy" {
  queue_url = aws_sqs_queue.pagamentos-queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.pagamentos-dlq-queue.arn]
  })
}

# ---- Pedidos Queue ----

# Create Pedidos SQS dlq Queue
resource "aws_sqs_queue" "pedidos-dlq-queue" {
  name = "${local.pedidos_queue_name}-dlq"
  tags = {
    Name = "${local.pedidos_queue_name}-dlq"
    application = var.lanchonete_application_tag_name
  }
}

# Create Pedidos SQS Queue
resource "aws_sqs_queue" "pedidos-queue" {
  name = local.pedidos_queue_name
  tags = {
    Name = local.pedidos_queue_name
    application = var.lanchonete_application_tag_name
  }
}

# Create Redrive Pedidos Queue policy
resource "aws_sqs_queue_redrive_allow_policy" "pedidos-queue-redrive-policy" {
  queue_url = aws_sqs_queue.pedidos-queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.pedidos-dlq-queue.arn]
  })
}
