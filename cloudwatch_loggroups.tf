resource "aws_cloudwatch_log_group" "loggroup" {
  count             = "${var.enable ? local.ecs_services_size : 0}"
  name              = "${format("%s/%s", aws_ecs_cluster.cluster.name, lookup(var.ecs_services[count.index], "name"))}"
  retention_in_days = "${var.ecs_cloudwatch_retention}"

  tags = "${merge(var.base_tags,
                  map("partner", var.partner),
                  map("system", var.system),
                  map("Name", format("%s-%s-lg", lookup(var.ecs_services[count.index], "name"), aws_ecs_cluster.cluster.name)))}"
}
