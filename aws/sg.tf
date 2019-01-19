resource "aws_security_group" "loadbalancer" {
  count  = "${var.enable ? 1 : 0}"
  name   = "${format("%s-lb-sg-%s-%s-%s", var.ecs_cluster_name, var.partner, var.system, var.environment)}"
  vpc_id = "${data.aws_vpc.target.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_tags,
                  map("partner", var.partner),
                  map("system", var.role_tags[var.ecs_cluster_name]),
                  map("Name", format("%s-lb-sg-%s-%s-%s", var.ecs_cluster_name, var.partner, var.system, var.environment)))}"
}

resource "aws_security_group_rule" "lb_https" {
  count       = "${var.enable ? 1 : 0}"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "TCP"
  description = "This rule allows the access to the ALB"

  cidr_blocks       = ["${var.service_allowed_cidr_blocks}"]
  security_group_id = "${aws_security_group.loadbalancer.id}"
}

resource "aws_security_group" "cluster" {
  count  = "${var.enable ? 1 : 0}"
  name   = "${format("%s-cluster-sg-%s-%s-%s", var.ecs_cluster_name, var.partner, var.system, var.environment)}"
  vpc_id = "${data.aws_vpc.target.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_tags,
                  map("partner", var.partner),
                  map("system", var.role_tags[var.ecs_cluster_name]),
                  map("Name", format("%s-cluster-sg-%s-%s-%s", var.ecs_cluster_name, var.partner, var.system, var.environment)))}"
}

resource "aws_security_group_rule" "lb_services" {
  count       = "${var.enable ? local.ecs_services_size : 0}"
  type        = "ingress"
  from_port   = "${lookup(var.ecs_services[count.index], "port")}"
  to_port     = "${lookup(var.ecs_services[count.index], "port")}"
  protocol    = "TCP"

  source_security_group_id = "${aws_security_group.loadbalancer.id}"
  security_group_id        = "${aws_security_group.cluster.id}"
}

resource "aws_security_group_rule" "vpc_services" {
  count     = "${var.enable ? local.ecs_services_size : 0}"
  type      = "ingress"
  from_port = "${lookup(var.ecs_services[count.index], "port")}"
  to_port   = "${lookup(var.ecs_services[count.index], "port")}"
  protocol  = "TCP"

  cidr_blocks       = ["${concat(list(data.aws_vpc.target.cidr_block), var.ecs_additional_allowed_cidr_blocks)}"]
  security_group_id = "${aws_security_group.cluster.id}"
}
