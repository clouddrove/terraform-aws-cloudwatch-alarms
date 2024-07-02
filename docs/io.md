## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| actions\_enabled | Indicates whether or not actions should be executed during any changes to the alarm's state. | `bool` | `true` | no |
| alarm\_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. | `list(any)` | `[]` | no |
| alarm\_description | The description for the alarm. | `string` | `""` | no |
| alarm\_name | The descriptive name for the alarm. | `string` | n/a | yes |
| comparison\_operator | The arithmetic operation to use when comparing the specified Statistic and Threshold. | `string` | n/a | yes |
| datapoints\_to\_alarm | Sets the number of datapoints that must be breaching to trigger the alarm. | `number` | `1` | no |
| dimensions | Dimensions for metrics. | `map(any)` | `{}` | no |
| enabled | Enable alarm. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| evaluation\_periods | The number of periods over which data is compared to the specified threshold. | `number` | n/a | yes |
| expression\_enabled | Enable alarm with expression. | `bool` | `false` | no |
| insufficient\_data\_actions | The list of actions to execute when this alarm transitions into an INSUFFICIENT\_DATA state from any other state. | `list(any)` | `[]` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| metric\_name | The name for the alarm's associated metric. | `string` | `"CPUUtilization"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| namespace | The namespace for the alarm's associated metric. | `string` | `"AWS/EC2"` | no |
| ok\_actions | The list of actions to execute when this alarm transitions into an OK state from any other state. | `list(any)` | `[]` | no |
| period | The period in seconds over which the specified statistic is applied. | `number` | `120` | no |
| query\_expressions | values for metric query expression. | `list(any)` | <pre>[<br>  {<br>    "expression": "ANOMALY_DETECTION_BAND(m1)",<br>    "id": "e1",<br>    "label": "CPUUtilization (Expected)",<br>    "return_data": "true"<br>  }<br>]</pre> | no |
| query\_metrics | values for metric query metrics. | `list(any)` | <pre>[<br>  {<br>    "dimensions": {<br>      "InstanceId": "i-abc123"<br>    },<br>    "id": "m1",<br>    "metric_name": "CPUUtilization",<br>    "namespace": "AWS/EC2",<br>    "period": "120",<br>    "return_data": "true",<br>    "stat": "Average",<br>    "unit": "Count"<br>  }<br>]</pre> | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-cloudwatch-alarms"` | no |
| statistic | The statistic to apply to the alarm's associated metric. | `string` | `"Average"` | no |
| threshold | The value against which the specified statistic is compared. | `number` | `40` | no |
| threshold\_metric\_id | If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY\_DETECTION\_BAND function. | `string` | `""` | no |
| treat\_missing\_data | Sets how an alarm is going to handle missing data points. | `string` | `"missing"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the cloudwatch metric alarm. |
| id | The ID of the health check. |
| tags | A mapping of tags to assign to the resource. |

