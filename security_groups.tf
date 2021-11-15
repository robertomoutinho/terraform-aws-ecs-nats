data "aws_vpc" "selected" {
  id = var.vpc_id
}

#########
## App ##
#########

module "app_sg" {

  source  = "terraform-aws-modules/security-group/aws"
  version = "v3.18.0"

  name        = "${var.environment}-${var.name}"
  vpc_id      = var.vpc_id
  description = "Security group with NATS ports open to VPC"

  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 4222
      to_port     = 4222
      protocol    = "tcp"
      description = "NATS Cluster from VPC"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    },
    {
      from_port   = 8222
      to_port     = 8222
      protocol    = "tcp"
      description = "NATS Cluster from VPC"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    },
    {
      from_port   = var.nats_cluster_port
      to_port     = var.nats_cluster_port
      protocol    = "tcp"
      description = "NATS Cluster from VPC"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    }
  ]

  egress_rules = ["all-all"]
  tags         = local.local_tags

}

#########
## EFS ##
#########

module "app_efs" {

  source  = "terraform-aws-modules/security-group/aws"
  version = "v3.18.0"

  name        = "${var.environment}-${var.name}-efs"
  vpc_id      = var.vpc_id
  description = "Security group to allow access to the EFS Mount"

  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]

  ingress_with_source_security_group_id = [
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      description              = "Allow NATS Cluster SG"
      source_security_group_id = module.app_sg.this_security_group_id
    },
  ]

  egress_rules = ["all-all"]
  tags         = local.local_tags

}