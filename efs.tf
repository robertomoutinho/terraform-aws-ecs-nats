resource "aws_efs_file_system" "this" {
  #checkov:skip=CKV2_AWS_18:"Ensure that Elastic File System (Amazon EFS) file systems are added in the backup plans of AWS Backup"
  encrypted = true
  tags = merge(
    local.local_tags,
    {
      Name = "${var.environment}-${var.name}-efs",
    }
  )
}

resource "aws_efs_mount_target" "mount" {
  for_each        = toset(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.key
  security_groups = [module.app_efs.this_security_group_id]
}