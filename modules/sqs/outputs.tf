output "producao_queue_url" { value = aws_sqs_queue.producao-queue.url }
output "producao_queue_dlq_url" { value = aws_sqs_queue.producao-dlq-queue.url }

output "pagamentos_queue_url" { value = aws_sqs_queue.pagamentos-queue.url }
output "pagamentos_queue_dlq_url" { value = aws_sqs_queue.pagamentos-dlq-queue.url }