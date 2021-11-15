locals {
  container_name  = var.name
  container_efs_mount_folder = "/opt/data/nats"
  routes = join(",",local.leaf_nodes)
  leaf_nodes = [
    for idx in var.nats_cluster_nodes : 
      format("nats://%s.%s:${var.nats_cluster_port}", idx, var.service_discovery_namespace)
  ]
}

##########
## NATS ##
##########

resource "aws_ecs_service" "nats_cluster" {
  for_each                           = toset(var.nats_cluster_nodes)
  name                               = "${var.name}-cluster-${each.key}"
  cluster                            = var.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.nats_cluster[each.key].arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  propagate_tags                     = "SERVICE"
  enable_ecs_managed_tags            = true
  deployment_maximum_percent         = var.ecs_service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_service_deployment_minimum_healthy_percent

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [module.app_sg.this_security_group_id]
    assign_public_ip = var.ecs_service_assign_public_ip
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.sds[each.key].arn
    container_name = local.container_name
  }

  tags = local.local_tags
}

module "container_definition_nats_cluster" {
  for_each = toset(var.nats_cluster_nodes)
  source   = "cloudposse/ecs-container-definition/aws"
  version  = "v0.58.1"

  container_name  = var.name
  container_image = var.docker_image
  entrypoint      = ["nats-server"]
  command         = [
    "--name",
    each.key,
    "--cluster",
    "nats://0.0.0.0:${var.nats_cluster_port}",
    "--cluster_name",
    var.nats_cluster_name,
    "--routes",
    local.routes,
    "--jetstream",
    "--store_dir",
    local.container_efs_mount_folder
  ]

  container_cpu                = var.ecs_task_cpu
  container_memory             = var.ecs_task_memory
  container_memory_reservation = var.container_memory_reservation

  port_mappings = [
    {
        containerPort = 4222
        hostPort      = 4222
        protocol      = "tcp"
    },
    {
        containerPort = 8222
        hostPort      = 8222
        protocol      = "tcp"
    },
    {
        containerPort = var.nats_cluster_port
        hostPort      = var.nats_cluster_port
        protocol      = "tcp"
    },
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-region        = data.aws_region.current.name
      awslogs-group         = aws_cloudwatch_log_group.app.name
      awslogs-stream-prefix = "ecs"
    }
    secretOptions = []
  }

  mount_points = [
    {
      containerPath = local.container_efs_mount_folder
      sourceVolume  = "nats-storage"
      readOnly      = false
    }
  ]

  environment = concat(
    var.custom_environment_variables,
    [ 
      {
        "name" : "ECS_ENABLE_CONTAINER_METADATA",
        "value" : true
      },
      {
        "name" : "AWS_DEFAULT_REGION",
        "value" : data.aws_region.current.name
      },
    ]
  )

  secrets     = var.custom_environment_secrets

}

resource "aws_ecs_task_definition" "nats_cluster" {
  for_each                 = toset(var.nats_cluster_nodes)
  family                   = "${var.environment}-${var.name}-cluster-${each.key}"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  container_definitions    = module.container_definition_nats_cluster[each.key].json_map_encoded_list
  tags                     = local.local_tags
  volume {
    name = "nats-storage"
    efs_volume_configuration {
      file_system_id  = aws_efs_file_system.this.id
    }
  }
  lifecycle {
    ignore_changes = [
      volume
    ]
  }
}