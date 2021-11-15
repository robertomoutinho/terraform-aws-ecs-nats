# AWS Terraform module which runs NATS Server on AWS Fargate

This repository contains Terraform infrastructure code which creates NATS Server on ECS Fargate.
For more information regarding NATS, visit: https://nats.io/

[![Checkov](https://github.com/robertomoutinho/terraform-aws-ecs-nats/actions/workflows/checkov.yml/badge.svg)](https://github.com/robertomoutinho/terraform-aws-ecs-nats/actions/workflows/checkov.yml)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.36.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.36.0, < 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_efs"></a> [app\_efs](#module\_app\_efs) | terraform-aws-modules/security-group/aws | v3.18.0 |
| <a name="module_app_sg"></a> [app\_sg](#module\_app\_sg) | terraform-aws-modules/security-group/aws | v3.18.0 |
| <a name="module_container_definition_nats_cluster"></a> [container\_definition\_nats\_cluster](#module\_container\_definition\_nats\_cluster) | cloudposse/ecs-container-definition/aws | v0.58.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.nats_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.nats_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.mount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_role.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_access_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs_task_access_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_service_discovery_service.sds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_task_access_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_access_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Retention period of app CloudWatch logs | `number` | `7` | no |
| <a name="input_container_memory_reservation"></a> [container\_memory\_reservation](#input\_container\_memory\_reservation) | The amount of memory (in MiB) to reserve for the container | `number` | `128` | no |
| <a name="input_custom_container_definitions"></a> [custom\_container\_definitions](#input\_custom\_container\_definitions) | A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used. | `string` | `""` | no |
| <a name="input_custom_environment_secrets"></a> [custom\_environment\_secrets](#input\_custom\_environment\_secrets) | List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`) | <pre>list(object(<br>    {<br>      name      = string<br>      valueFrom = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_custom_environment_variables"></a> [custom\_environment\_variables](#input\_custom\_environment\_variables) | List of additional environment variables the container will use (list should contain maps with `name` and `value`) | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | The docker image to be used. If set, app\_ecr\_image\_repo will be ignored | `string` | `"nats:latest"` | no |
| <a name="input_ecs_cluster_id"></a> [ecs\_cluster\_id](#input\_ecs\_cluster\_id) | The ECS cluster ID | `any` | n/a | yes |
| <a name="input_ecs_service_assign_public_ip"></a> [ecs\_service\_assign\_public\_ip](#input\_ecs\_service\_assign\_public\_ip) | Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html) | `bool` | `false` | no |
| <a name="input_ecs_service_deployment_maximum_percent"></a> [ecs\_service\_deployment\_maximum\_percent](#input\_ecs\_service\_deployment\_maximum\_percent) | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment | `number` | `200` | no |
| <a name="input_ecs_service_deployment_minimum_healthy_percent"></a> [ecs\_service\_deployment\_minimum\_healthy\_percent](#input\_ecs\_service\_deployment\_minimum\_healthy\_percent) | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment | `number` | `50` | no |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | The number of cpu units used by the task | `number` | `256` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | The amount (in MiB) of memory used by the task | `number` | `512` | no |
| <a name="input_enable_service_discovery"></a> [enable\_service\_discovery](#input\_enable\_service\_discovery) | Whether the service should be registered with Service Discovery. In order to use Service Disovery, an existing DNS Namespace must exist and be passed in. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to use on all resources created (VPC, ALB, etc) | `string` | `"app"` | no |
| <a name="input_nats_cluster_name"></a> [nats\_cluster\_name](#input\_nats\_cluster\_name) | The NATS cluster name | `string` | `"nats"` | no |
| <a name="input_nats_cluster_nodes"></a> [nats\_cluster\_nodes](#input\_nats\_cluster\_nodes) | The NATS cluster name | `list(string)` | <pre>[<br>  "n1",<br>  "n2",<br>  "n3"<br>]</pre> | no |
| <a name="input_nats_cluster_port"></a> [nats\_cluster\_port](#input\_nats\_cluster\_port) | The NATS cluster name | `string` | `"6222"` | no |
| <a name="input_policies_arn"></a> [policies\_arn](#input\_policies\_arn) | A list of the ARN of the policies you want to apply | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"<br>]</pre> | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of IDs of existing private subnets inside the VPC | `list(string)` | n/a | yes |
| <a name="input_service_discovery_dns_record_type"></a> [service\_discovery\_dns\_record\_type](#input\_service\_discovery\_dns\_record\_type) | The type of the resource, which indicates the value that Amazon Route 53 returns in response to DNS queries. One of `A` or `SRV`. | `string` | `"A"` | no |
| <a name="input_service_discovery_dns_ttl"></a> [service\_discovery\_dns\_ttl](#input\_service\_discovery\_dns\_ttl) | The amount of time, in seconds, that you want DNS resolvers to cache the settings for this resource record set. | `number` | `10` | no |
| <a name="input_service_discovery_failure_threshold"></a> [service\_discovery\_failure\_threshold](#input\_service\_discovery\_failure\_threshold) | The number of 30-second intervals that you want service discovery to wait before it changes the health status of a service instance. Maximum value of 10. | `number` | `1` | no |
| <a name="input_service_discovery_namespace"></a> [service\_discovery\_namespace](#input\_service\_discovery\_namespace) | The ID of the namespace to use for private DNS configuration. | `string` | n/a | yes |
| <a name="input_service_discovery_namespace_id"></a> [service\_discovery\_namespace\_id](#input\_service\_discovery\_namespace\_id) | The ID of the namespace to use for private DNS configuration. | `string` | n/a | yes |
| <a name="input_service_discovery_routing_policy"></a> [service\_discovery\_routing\_policy](#input\_service\_discovery\_routing\_policy) | The routing policy that you want to apply to all records that Route 53 creates when you register an instance and specify the service. One of `MULTIVALUE` or `WEIGHTED`. | `string` | `"MULTIVALUE"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of an existing VPC where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_security_group"></a> [ecs\_security\_group](#output\_ecs\_security\_group) | Security group assigned to ECS Service in network configuration |
| <a name="output_service_discovery_name"></a> [service\_discovery\_name](#output\_service\_discovery\_name) | The Service Discovery DNS name |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The app ECS task role arn |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC that was created or passed in |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
