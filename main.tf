##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  environment = var.environment
  repository  = var.repository
  managedby   = var.managedby
  label_order = var.label_order
  enabled     = var.enabled
}

##-----------------------------------------------------------------------------
## creates Cloudwatch Alarm on AWS for monitoriing AWS services.
##-----------------------------------------------------------------------------
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
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  tags                      = module.labels.tags

  dimensions = var.dimensions
}

##-----------------------------------------------------------------------------
## creates Cloudwatch Alarm on AWS for monitoriing AWS services.
##-----------------------------------------------------------------------------
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
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
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

##-----------------------------------------------------------------------------
## creates Cloudwatch Alarm on AWS for monitoriing AWS services.
##-----------------------------------------------------------------------------
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
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
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
