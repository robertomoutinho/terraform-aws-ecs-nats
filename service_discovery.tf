resource "aws_service_discovery_service" "sds" {

  for_each = { 
    for st in toset(var.nats_cluster_nodes) : 
      st => st if var.enable_service_discovery 
  }

  name  = each.key

  dns_config {
    namespace_id = var.service_discovery_namespace_id
    dns_records {
      ttl  = var.service_discovery_dns_ttl
      type = var.service_discovery_dns_record_type
    }
    routing_policy = var.service_discovery_routing_policy
  }

  health_check_custom_config {
    failure_threshold = var.service_discovery_failure_threshold
  }

  tags = local.local_tags

}