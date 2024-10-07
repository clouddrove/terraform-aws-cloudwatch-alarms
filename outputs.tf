#Module      : CLOUDWATCH METRIC ALARM
#Description : Terraform module creates Cloudwatch Alarm on AWS for monitoriing AWS services.
output "id" {
  value       = var.threshold_metric_id == "" ? (var.expression_enabled ? aws_cloudwatch_metric_alarm.expression[*].id : aws_cloudwatch_metric_alarm.default[*].id) : aws_cloudwatch_metric_alarm.anomaly[*].id
  description = "The ID of the health check."
}

output "arn" {
  value       = var.threshold_metric_id == "" ? (var.expression_enabled ? aws_cloudwatch_metric_alarm.expression[*].arn : aws_cloudwatch_metric_alarm.default[*].arn) : aws_cloudwatch_metric_alarm.anomaly[*].arn
  description = "The ARN of the cloudwatch metric alarm."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}
