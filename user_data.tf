module "user_data_ecs" {
  source = "git::ssh://git@github.com/jjuarez/terraform-userdataecs//aws?ref=0.1.0"

  ecs_cluster_name         = "${aws_ecs_cluster.cluster.name}"
  ecs_instance_hostname    = "${var.ecs_instance_hostname}"
  ecs_instance_domain      = "${var.internal_dns_domain}"
  ecs_config               = "${var.ecs_config}"
  ecs_logging              = "${var.ecs_logging}"
  ecs_loglevel             = "${var.ecs_loglevel}"
  ecs_custom_userdata      = "${var.ecs_custom_userdata}"
  ecs_enable_node_exporter = "${var.ecs_enable_node_exporter}"
  ecs_cloudwatch_prefix    = "${var.ecs_cloudwatch_prefix}"
}
