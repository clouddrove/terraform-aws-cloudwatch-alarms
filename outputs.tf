#Module      : CLOUDWATCH METRIC ALARM
#Description : Terraform module creates Cloudwatch Alarm on AWS for monitoriing AWS services.
output "id" {
  value       = aws_cloudwatch_metric_alarm.default.*.id
  description = "The ID of the health check."
}

output "arn" {
  value       = aws_cloudwatch_metric_alarm.default.*.arn
  description = "The ARN of the cloudwatch metric alarm."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}