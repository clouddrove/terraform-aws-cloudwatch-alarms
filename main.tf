# Managed By : CloudDrove
# Description : This Script is used to create Cloudwatch Alarms.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-labels.git"

  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
}

#Module      : CLOUDWATCH METRIC ALARM
#Description : Terraform module creates Cloudwatch Alarm on AWS for monitoriing AWS services.
resource "aws_cloudwatch_metric_alarm" "default" {
  count = var.enabled == true ? 1 : 0

  alarm_name                = var.alarm_name
  alarm_description         = var.alarm_description
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_actions             = var.alarm_actions
  actions_enabled           = var.actions_enabled
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions                = var.ok_actions
  tags                      = module.labels.tags

  dimensions = {
    InstanceId = var.instance_id,
    instance   = "Ec2:",
    objectname = "LogicalDisk"
  }
}