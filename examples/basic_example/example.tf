##---------------------------------------------------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
##--------------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

##---------------------------------------------------------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
##--------------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]
  cidr_block  = "172.16.0.0/16"
}

##-----------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
##-----------------------------------------------------
module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.1"

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

##-----------------------------------------------------
## Amazon EC2 provides cloud hosted virtual machines, called "instances", to run applications.
##-----------------------------------------------------
module "ec2" {
  source      = "clouddrove/ec2/aws"
  version     = "2.0.3"
  name        = "ec2-instance"
  environment = "test"
  label_order = ["name", "environment"]

  ####----------------------------------------------------------------------------------
  ## Below A security group controls the traffic that is allowed to reach and leave the resources that it is associated with.
  ####----------------------------------------------------------------------------------
  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [22, 80, 443]

  instance_count              = 1
  ami                         = "ami-08d658f84a6d84a80"
  ebs_optimized               = "false"
  instance_type               = "t2.nano"
  monitoring                  = true
  associate_public_ip_address = true
  tenancy                     = "default"
  subnet_ids                  = tolist(module.public_subnets.public_subnet_id)
  assign_eip_address          = "true"
  ebs_volume_enabled          = "true"
  ebs_volume_type             = "gp2"
  ebs_volume_size             = 30
  user_data                   = "./_bin/user_data.sh"
}

##-----------------------------------------------------------------------------
## alarm module call.
##-----------------------------------------------------------------------------
module "alarm" {
  source = "../../"

  name        = "alarm"
  environment = "test"
  label_order = ["name", "environment"]

  alarm_name                = "cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 40
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = []
  actions_enabled           = true
  insufficient_data_actions = []
  ok_actions                = []
  dimensions = {
    instance_id = module.ec2.instance_id[0]
  }
}
