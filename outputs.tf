output "task_role_arn" {
  description = "The app ECS task role arn"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "vpc_id" {
  description = "ID of the VPC that was created or passed in"
  value       = var.vpc_id
}

output "ecs_security_group" {
  description = "Security group assigned to ECS Service in network configuration"
  value       = module.app_sg.this_security_group_id
}

output "service_discovery_name" {
  description = "The Service Discovery DNS name"
  value       = try(aws_service_discovery_service.sds.0.name, null)
}
