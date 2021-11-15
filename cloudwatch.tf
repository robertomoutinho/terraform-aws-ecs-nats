#####################
## Cloudwatch logs ##
#####################

resource "aws_cloudwatch_log_group" "app" {
  #checkov:skip=CKV_AWS_158:"Ensure that CloudWatch Log Group is encrypted by KMS"
  name              = "${var.environment}-${var.name}"
  retention_in_days = var.cloudwatch_log_retention_in_days
  tags              = local.local_tags
}
