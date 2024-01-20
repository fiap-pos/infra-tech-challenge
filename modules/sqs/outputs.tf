output "producao_queue_url" { value = aws_sqs_queue.producao-queue.url }
output "producao_queue_dlq_url" { value = aws_sqs_queue.producao-dlq-queue.url }