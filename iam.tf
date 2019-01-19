resource "aws_iam_instance_profile" "ecs_instance" {
  count = "${var.enable ? 1 : 0}"
  name  = "${format("ecs-instance-%s", aws_ecs_cluster.cluster.name)}"
  role  = "${aws_iam_role.ecs_instance.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ecs_instance" {
  count              = "${var.enable ? 1 : 0}"
  name               = "${format("ecs-instance-%s", aws_ecs_cluster.cluster.name)}"
  assume_role_policy = "${file("${path.module}/files/policies/ecs-instance.json")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecs_instance_policy" {
  count  = "${var.enable ? 1 : 0}"
  name   = "${format("ecs-instance-policy-%s", aws_ecs_cluster.cluster.name)}"
  role   = "${aws_iam_role.ecs_instance.name}"
  policy = "${file("${path.module}/files/policies/ecs-instance-policy.json")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ecs_service" {
  count              = "${var.enable ? 1 : 0}"
  name               = "${format("ecs-service-%s", aws_ecs_cluster.cluster.name)}"
  assume_role_policy = "${file("${path.module}/files/policies/ecs-service.json")}"
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  count      = "${var.enable ? 1 : 0}"
  role       = "${aws_iam_role.ecs_service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role" "ecs_service_autoscale" {
  count              = "${var.enable ? 1 : 0}"
  name               = "${format("ecs-service-autoscale-%s", aws_ecs_cluster.cluster.name)}"
  assume_role_policy = "${file("${path.module}/files/policies/ecs-service-autoscale.json")}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_autoscale" {
  count      = "${var.enable ? 1 : 0}"
  role       = "${aws_iam_role.ecs_service_autoscale.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}
