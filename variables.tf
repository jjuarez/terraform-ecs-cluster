// Switch
variable "enable" {}

// Hierarchy
variable "partner" {}
variable "system" {}
variable "environment" {}

// VPC variables
variable "vpc_id" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

// Services DNS variables
variable "reverse_internal_dns_zone_id" {}

variable "internal_dns_domain" {}
variable "internal_dns_ttl" {}
variable "public_dns_domain" {}
variable "public_dns_ttl" {}
variable "certificate_arn" {}

variable "service_allowed_cidr_blocks" {
  type = "list"
}

variable "ecs_additional_allowed_sg_ids" {
  type = "list"
}

variable "ecs_additional_allowed_cidr_blocks" {
  type = "list"
}

// ALB specific variables
variable "deregistration_delay" {}

// ECS specific variables
variable "ecs_cluster_name" {}

variable "ecs_instance_hostname" {}
variable "ecs_config" {}
variable "ecs_logging" {}
variable "ecs_loglevel" {}
variable "ecs_custom_userdata" {}
variable "ecs_enable_node_exporter" {}
variable "ecs_cloudwatch_prefix" {}
variable "ecs_cloudwatch_retention" {}

variable "ecs_services" {
  type = "list"
}

// ECS EC2 specific variables
variable "instance_type" {}

variable "enable_monitoring" {}
variable "ebs_optimized" {}
variable "key_name" {}
variable "associate_public_ip_address" {}

// ECS ASG variables
variable "ecs_memory_high_evaluation_periods" {}

variable "ecs_memory_low_evaluation_periods" {}
variable "ecs_cpu_high_evaluation_periods" {}
variable "ecs_cpu_low_evaluation_periods" {}
variable "ecs_memory_high_period" {}
variable "ecs_memory_low_period" {}
variable "ecs_cpu_high_period" {}
variable "ecs_cpu_low_period" {}
variable "ecs_memory_high_threshold" {}
variable "ecs_memory_low_threshold" {}
variable "ecs_cpu_high_threshold" {}
variable "ecs_cpu_low_threshold" {}

// ASG variables
variable "asg_max_size" {}
variable "asg_min_size" {}
variable "desired_capacity" {}
variable "default_cooldown" {}
variable "health_check_grace_period" {}

// Tags
variable "base_tags" {
  type = "map"
}

variable "role_tags" {
  type = "map"
}
