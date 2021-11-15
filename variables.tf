variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
}

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type        = string
  default     = "app"
}

# VPC
variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of IDs of existing private subnets inside the VPC"
  type        = list(string)
}

# Cloudwatch
variable "cloudwatch_log_retention_in_days" {
  description = "Retention period of app CloudWatch logs"
  type        = number
  default     = 7
}

# ECS Service / Task
variable "ecs_cluster_id" {
  description = "The ECS cluster ID"
}

variable "ecs_service_assign_public_ip" {
  description = "Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html)"
  type        = bool
  default     = false
}

variable "policies_arn" {
  description = "A list of the ARN of the policies you want to apply"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

variable "ecs_service_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "ecs_service_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 50
}

variable "ecs_task_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = number
  default     = 512
}

variable "container_memory_reservation" {
  description = "The amount of memory (in MiB) to reserve for the container"
  type        = number
  default     = 128
}

variable "custom_container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used."
  type        = string
  default     = ""
}

# NATS

variable "docker_image" {
  description = "The docker image to be used. If set, app_ecr_image_repo will be ignored"
  type        = string
  default     = "nats:latest"
}

variable "nats_cluster_name" {
  description = "The NATS cluster name"
  type        = string
  default     = "nats"
}

variable "nats_cluster_nodes" {
  description = "The NATS cluster name"
  type        = list(string)
  default     = ["n1", "n2", "n3"]
}

variable "nats_cluster_port" {
  description = "The NATS cluster name"
  type        = string
  default     = "6222"
}

variable "custom_environment_secrets" {
  description = "List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`)"
  type = list(object(
    {
      name      = string
      valueFrom = string
    }
  ))
  default = []
}

variable "custom_environment_variables" {
  description = "List of additional environment variables the container will use (list should contain maps with `name` and `value`)"
  type = list(object(
    {
      name  = string
      value = string
    }
  ))
  default = []
}

## Service discovery
variable "enable_service_discovery" {
  description = "Whether the service should be registered with Service Discovery. In order to use Service Disovery, an existing DNS Namespace must exist and be passed in."
  type        = bool
  default     = false
}

variable "service_discovery_namespace" {
  description = "The ID of the namespace to use for private DNS configuration."
  type        = string
}

variable "service_discovery_namespace_id" {
  description = "The ID of the namespace to use for private DNS configuration."
  type        = string
}

variable "service_discovery_dns_record_type" {
  description = "The type of the resource, which indicates the value that Amazon Route 53 returns in response to DNS queries. One of `A` or `SRV`."
  type        = string
  default     = "A"
}

variable "service_discovery_dns_ttl" {
  description = "The amount of time, in seconds, that you want DNS resolvers to cache the settings for this resource record set."
  type        = number
  default     = 10
}

variable "service_discovery_routing_policy" {
  description = "The routing policy that you want to apply to all records that Route 53 creates when you register an instance and specify the service. One of `MULTIVALUE` or `WEIGHTED`."
  type        = string
  default     = "MULTIVALUE"
}

variable "service_discovery_failure_threshold" {
  description = "The number of 30-second intervals that you want service discovery to wait before it changes the health status of a service instance. Maximum value of 10."
  type        = number
  default     = 1
}