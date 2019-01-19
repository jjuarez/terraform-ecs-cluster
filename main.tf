data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "azs" {}

data "aws_vpc" "target" {
  id = "${var.vpc_id}"
}

data "aws_route53_zone" "direct_internal" {
  name         = "${var.internal_dns_domain}"
  private_zone = true
}

data "aws_route53_zone" "public" {
  name         = "${var.public_dns_domain}"
  private_zone = false
}

data "aws_elb_service_account" "main" {}

locals {
  full_cluster_name = "${lower(format("%s-%s-%s-%s", var.ecs_cluster_name, var.partner, var.system, var.environment))}"
  ecs_services_size = "${length(var.ecs_services)}"

  default_network_mode = "bridge"
  default_protocol     = "tcp"
  default_environment  = "[]"
  default_cpu          = "0"
  default_log_driver   = "awslogs"

  default_desired_tasks                      = 1
  default_deployment_maximum_percent         = 200
  default_deployment_minimum_healthy_percent = 50
}
