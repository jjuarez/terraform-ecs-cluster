resource "aws_lb" "lb" {
  count              = "${var.enable ? 1 : 0}"
  name               = "${format("%s-lb", aws_ecs_cluster.cluster.name)}"
  internal           = false
  load_balancer_type = "application"

  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.loadbalancer.id}"]

  tags = "${merge(var.base_tags,
                  map("partner", var.partner),
                  map("system", var.role_tags[var.ecs_cluster_name]),
                  map("Name", format("%s-lb", aws_ecs_cluster.cluster.name)))}"
}

resource "aws_lb_listener" "https" {
  count             = "${var.enable ? 1 : 0}"
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.cluster.0.arn}"
    type             = "forward"
  }
}

//
// Rules for the HTTPS listener
//
resource "aws_lb_listener_rule" "https_rule" {
  count        = "${var.enable ? local.ecs_services_size : 0}"
  listener_arn = "${aws_lb_listener.https.arn}"
  priority     = "${100 - count.index}"

  action {
    target_group_arn = "${element(aws_lb_target_group.cluster.*.arn, count.index)}"
    type             = "forward"
  }

  condition {
    field = "path-pattern"

    values = [
      "${lookup(var.ecs_services[count.index], "path_pattern")}",
    ]
  }
}

//
// Services target groups
//
resource "aws_lb_target_group" "tg" {
  count    = "${var.enable ? local.ecs_services_size : 0}"
  name     = "${format("%s-%s-tg", lookup(var.ecs_services[count.index], "name"), aws_ecs_cluster.cluster.name)}"
  port     = "${lookup(var.ecs_services[count.index], "port")}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  deregistration_delay = 300

  health_check {
    interval            = 30
    path                = "${lookup(var.ecs_services[count.index], "health_check", "/healthz")}"
    protocol            = "HTTP"
    port                = "${lookup(var.ecs_services[count.index], "port")}"
    timeout             = 10
    healthy_threshold   = 5
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = "${merge(var.base_tags,
                  map("partner", var.partner),
                  map("system", var.role_tags[var.ecs_cluster_name]),
                  map("Name", format("%s-%s-tg", lookup(var.ecs_services[count.index], "name"), aws_ecs_cluster.cluster.name)))}"
}
