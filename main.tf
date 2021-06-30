# Managed By : CloudDrove
# Description : This Script is used to create Cloudwatch Alarms.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  name        = var.name
  environment = var.environment
  repository  = var.repository
  managedby   = var.managedby
  label_order = var.label_order
  enabled     = var.enabled
}

#Module      : CLOUDWATCH METRIC ALARM
#Description : Terraform module creates Cloudwatch Alarm on AWS for monitoriing AWS services.
resource "aws_cloudwatch_metric_alarm" "default" {
  count = var.enabled == true && var.expression_enabled == false && var.threshold_metric_id == "" ? 1 : 0

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

  dimensions = var.dimensions
}

#Module      : CLOUDWATCH METRIC ALARM
#Description : Terraform module creates Cloudwatch Alarm on AWS for monitoriing AWS services.
resource "aws_cloudwatch_metric_alarm" "expression" {
  count = var.enabled == true && var.expression_enabled == true && var.threshold_metric_id == "" ? 1 : 0

  alarm_name                = var.alarm_name
  alarm_description         = var.alarm_description
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  threshold                 = var.threshold
  alarm_actions             = var.alarm_actions
  actions_enabled           = var.actions_enabled
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions                = var.ok_actions
  tags                      = module.labels.tags
  dynamic "metric_query" {
    for_each = var.query_expressions
    content {
      id          = metric_query.value.id
      expression  = metric_query.value.expression
      label       = metric_query.value.label
      return_data = metric_query.value.return_data
    }
  }

  dynamic "metric_query" {
    for_each = var.query_metrics
    content {
      id          = metric_query.value.id
      return_data = metric_query.value.return_data
      metric {
        metric_name = metric_query.value.metric_name
        namespace   = metric_query.value.namespace
        period      = metric_query.value.period
        stat        = metric_query.value.stat
        unit        = metric_query.value.unit

        dimensions = metric_query.value.dimensions
      }
    }
  }

}

#Module      : CLOUDWATCH METRIC ALARM
#Description : Terraform module creates Cloudwatch Alarm on AWS for monitoriing AWS services.
resource "aws_cloudwatch_metric_alarm" "anomaly" {
  count = var.enabled == true && var.expression_enabled == false && var.threshold_metric_id != "" ? 1 : 0

  alarm_name                = var.alarm_name
  alarm_description         = var.alarm_description
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  threshold_metric_id       = var.threshold_metric_id
  alarm_actions             = var.alarm_actions
  actions_enabled           = var.actions_enabled
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions                = var.ok_actions
  tags                      = module.labels.tags
  dynamic "metric_query" {
    for_each = var.query_expressions
    content {
      id          = metric_query.value.id
      expression  = metric_query.value.expression
      label       = metric_query.value.label
      return_data = metric_query.value.return_data
    }
  }

  dynamic "metric_query" {
    for_each = var.query_metrics
    content {
      id          = metric_query.value.id
      return_data = metric_query.value.return_data
      metric {
        metric_name = metric_query.value.metric_name
        namespace   = metric_query.value.namespace
        period      = metric_query.value.period
        stat        = metric_query.value.stat
        unit        = metric_query.value.unit

        dimensions = metric_query.value.dimensions
      }
    }
  }

}