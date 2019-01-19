resource "aws_ecs_cluster" "cluster" {
  count = "${var.enable ? 1 : 0}"
  name  = "${local.full_cluster_name}"

  lifecycle {
    create_before_destroy = true
  }
}
