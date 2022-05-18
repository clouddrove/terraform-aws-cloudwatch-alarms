provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]


  cidr_block = "172.16.0.0/16"
}

module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.3"

  name        = "public-subnet"
  environment = "test"
  label_order = ["name", "environment"]


  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
}

module "http-https" {
  source  = "clouddrove/security-group/aws"
  version = "1.0.1"


  name        = "http-https"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
}

module "ssh" {
  source  = "clouddrove/security-group/aws"
  version = "1.0.1"


  name        = "ssh"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [22]
}

module "ec2" {
  source  = "clouddrove/ec2/aws"
  version = "1.0.1"
  name        = "ec2-instance"
  environment = "test"
  label_order = ["name", "environment"]


  instance_count              = 1
  ami                         = "ami-08d658f84a6d84a80"
  ebs_optimized               = "false"
  instance_type               = "t2.nano"
  monitoring                  = true
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
  environment = "test"
  label_order = ["name", "environment"]


  alarm_name          = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 40
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = []

  actions_enabled           = true
  insufficient_data_actions = []
  ok_actions                = []
  dimensions = {
    instance_id = module.ec2.instance_id[0]
  }
}