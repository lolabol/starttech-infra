output "backend_log_group" {
  description = "Backend CloudWatch log group name"
  value = aws_cloudwatch_log_group.backend.name
}

output "frontend_log_group" {
  description = "Frontend CloudWatch log group name"
  value = aws_cloudwatch_log_group.frontend.name
}

output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value = aws_cloudwatch_dashboard.main.dashboard_name
}
