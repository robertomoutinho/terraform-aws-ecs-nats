data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {

  local_tags = var.tags
  
}