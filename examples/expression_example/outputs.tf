output "arn" {
  value       = module.alarm[*].arn
  description = "The ARN of the cloudwatch metric alarm."
}

output "tags" {
  value       = module.alarm.tags
  description = "A mapping of tags to assign to the Cloudwatch Alarm."
}