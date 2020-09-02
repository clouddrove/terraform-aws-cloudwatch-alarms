provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git"

  name        = "vpc"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  cidr_block = "172.16.0.0/16"
}

module "public_subnets" {
  source = "git::https://github.com/clouddrove/terraform-aws-subnet.git"

  name        = "public-subnet"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
}

module "http-https" {
  source = "git::https://github.com/clouddrove/terraform-aws-security-group.git"

  name        = "http-https"
  application = "clouddrove"
  label_order = ["environment", "name", "application"]

  environment   = "test"
  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
}

module "ssh" {
  source = "git::https://github.com/clouddrove/terraform-aws-security-group.git"

  name        = "ssh"
  application = "clouddrove"
  label_order = ["environment", "name", "application"]

  environment   = "test"
  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [22]
}

module "ec2" {
  source = "git::https://github.com/clouddrove/terraform-aws-ec2.git"

  name        = "ec2-instance"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  instance_count              = 1
  ami                         = "ami-08d658f84a6d84a80"
  ebs_optimized               = "false"
  instance_type               = "t2.nano"
  monitoring                  = false
  associate_public_ip_address = true
  tenancy                     = "default"
  disk_size                   = 8
  vpc_security_group_ids_list = [module.ssh.security_group_ids, module.http-https.security_group_ids]
  subnet_ids                  = tolist(module.public_subnets.public_subnet_id)

  assign_eip_address = "true"

  ebs_volume_enabled = "true"
  ebs_volume_type    = "gp2"
  ebs_volume_size    = 30
  user_data          = "./_bin/user_data.sh"
}

module "alarm" {
  source = "../../"

  name        = "alarm"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  expression_enabled  = true
  alarm_name          = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 40
  query_expressions = [{
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }]
  query_metrics = [
    {
      id          = "m1"
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"
      return_data = null
      dimensions = {
        LoadBalancer = "app/web"
      }
      }, {
      id          = "m2"
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"
      return_data = null
      dimensions = {
        LoadBalancer = "app/web"
      }
  }]
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = []

  actions_enabled           = true
  insufficient_data_actions = []
  ok_actions                = []
}