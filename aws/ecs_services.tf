data "aws_ecr_repository" "registry" {
  count = "${var.enable ? local.ecs_services_size : 0}"
  name  = "${lookup(var.ecs_services[count.index], "image_name")}"
}

data "template_file" "task" {
  count    = "${var.enable ? local.ecs_services_size : 0}"
  template = "${file("${path.module}/templates/tasks/task-td.json.tpl")}"

  vars {
    name             = "${lookup(var.ecs_services[count.index], "name")}"
    image_url        = "${format("%s:%s", element(data.aws_ecr_repository.registry.*.repository_url, count.index), lookup(var.ecs_services[count.index], "image_tag"))}"
    cpu              = "${lookup(var.ecs_services[count.index], "cpu", local.default_cpu)}"
    memory           = "${lookup(var.ecs_services[count.index], "memory")}"
    environment      = "${lookup(var.ecs_services[count.index], "environment", local.default_environment)}"
    network_mode     = "${lookup(var.ecs_services[count.index], "network_mode", local.default_network_mode)}"
    port             = "${lookup(var.ecs_services[count.index], "port")}"
    protocol         = "${lookup(var.ecs_services[count.index], "protocol", local.default_protocol)}"
    log_driver       = "${lookup(var.ecs_services[count.index], "log_driver", local.default_log_driver)}"
    log_group_name   = "${format("%s/%s", aws_ecs_cluster.cluster.name, lookup(var.ecs_services[count.index], "name"))}"
    log_group_region = "${data.aws_region.current.name}"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  count                 = "${var.enable ? local.ecs_services_size : 0}"
  family                = "${format("%s-td-%s", lookup(var.ecs_services[count.index], "name"), aws_ecs_cluster.cluster.name)}"
  container_definitions = "${element(data.template_file.task.*.rendered, count.index)}"
  network_mode          = "${lookup(var.ecs_services[count.index], "network_mode", local.default_network_mode)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "service" {
  count           = "${var.enable ? local.ecs_services_size : 0}"
  name            = "${lookup(var.ecs_services[count.index], "name")}"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${element(aws_ecs_task_definition.task_definition.*.arn, count.index)}"

  desired_count                      = "${lookup(var.ecs_services[count.index], "desired_tasks", 1)}"
  deployment_maximum_percent         = "${lookup(var.ecs_services[count.index], "deployment_maximum_percent", local.default_deployment_maximum_percent)}"
  deployment_minimum_healthy_percent = "${lookup(var.ecs_services[count.index], "deployment_minimum_healthy_percent", local.default_deployment_minimum_healthy_percent)}"

  health_check_grace_period_seconds = 30

  load_balancer {
    target_group_arn = "${element(aws_lb_target_group.cluster.*.arn, count.index)}"
    container_name   = "${lookup(var.ecs_services[count.index], "image_name")}"
    container_port   = "${lookup(var.ecs_services[count.index], "port")}"
  }
}
