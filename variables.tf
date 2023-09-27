#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-cloudwatch-alarms"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

#Module      : CLOUDWATCH METRIC ALARM
#Description : Provides a CloudWatch Metric Alarm resource.
variable "enabled" {
  type        = bool
  default     = true
  description = "Enable alarm."
}

variable "expression_enabled" {
  type        = bool
  default     = false
  description = "Enable alarm with expression."
}

variable "alarm_name" {
  type        = string
  description = "The descriptive name for the alarm."
}

variable "alarm_description" {
  type        = string
  default     = ""
  description = "The description for the alarm."
}

variable "comparison_operator" {
  type        = string
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold."
  sensitive   = true
}

variable "evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold."
}

variable "metric_name" {
  type        = string
  default     = "CPUUtilization"
  description = "The name for the alarm's associated metric."
}

variable "namespace" {
  type        = string
  default     = "AWS/EC2"
  description = "The namespace for the alarm's associated metric."
  sensitive   = true
}

variable "period" {
  type        = number
  default     = 120
  description = "The period in seconds over which the specified statistic is applied."
}

variable "statistic" {
  type        = string
  default     = "Average"
  description = "The statistic to apply to the alarm's associated metric."
}

variable "threshold" {
  type        = number
  default     = 40
  description = "The value against which the specified statistic is compared."
}

variable "threshold_metric_id" {
  type        = string
  default     = ""
  description = "If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY_DETECTION_BAND function."
}

variable "alarm_actions" {
  type        = list(any)
  default     = []
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state."
}

variable "actions_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether or not actions should be executed during any changes to the alarm's state."
}

variable "insufficient_data_actions" {
  type        = list(any)
  default     = []
  description = "The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state."
}

variable "ok_actions" {
  type        = list(any)
  default     = []
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state."
}

variable "dimensions" {
  type        = map(any)
  default     = {}
  description = "Dimensions for metrics."
}

variable "query_expressions" {
  type = list(any)
  default = [{
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CPUUtilization (Expected)"
    return_data = "true"
  }]
  description = "values for metric query expression."
}

variable "query_metrics" {
  type = list(any)
  default = [{
    id          = "m1"
    return_data = "true"
    metric_name = "CPUUtilization"
    namespace   = "AWS/EC2"
    period      = "120"
    stat        = "Average"
    unit        = "Count"
    dimensions = {
      InstanceId = "i-abc123"
    }
  }]
  description = "values for metric query metrics."
}

variable "enable_security_group" {
  type        = bool
  default     = true
  description = "Enable default Security Group with only Egress traffic allowed."
}

variable "sg_ids" {
  type        = list(any)
  default     = []
  description = "of the security group id."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC that the instance security group belongs to."
  sensitive   = true
}

variable "sg_description" {
  type        = string
  default     = "Instance default security group (only egress access is allowed)."
  description = "The security group description."
}

variable "is_external" {
  type        = bool
  default     = false
  description = "enable to udated existing security Group"
}

variable "egress_rule" {
  type        = bool
  default     = true
  description = "Enable to create egress rule"
}

variable "sg_egress_description" {
  type        = string
  default     = "Description of the rule."
  description = "Description of the egress and ingress rule"
}

variable "sg_egress_ipv6_description" {
  type        = string
  default     = "Description of the rule."
  description = "Description of the egress_ipv6 rule"
}

variable "allowed_ip" {
  type        = list(any)
  default     = []
  description = "List of allowed ip."
}

variable "allowed_ports" {
  type        = list(any)
  default     = []
  description = "List of allowed ingress ports"
}

variable "sg_ingress_description" {
  type        = string
  default     = "Description of the ingress rule use elasticache."
  description = "Description of the ingress rule"
}

variable "protocol" {
  type        = string
  default     = "tcp"
  description = "The protocol. If not icmp, tcp, udp, or all use the."
}