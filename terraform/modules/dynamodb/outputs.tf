output "dynamodb_arn" {
  value       = aws_dynamodb_table.url_shortener_table.arn
  description = "The DynamoDB table ARN"
}