locals {
  lc_name_prefix = "${format("%s-lc-", aws_ecs_cluster.cluster.name)}"
}

resource "aws_launch_configuration" "lc" {
  count         = "${var.enable ? 1 : 0}"
  name_prefix   = "${local.lc_name_prefix}"
  image_id      = "${module.ami.id}"
  instance_type = "${var.instance_type}"

  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"

  key_name = "${var.key_name}"

  security_groups = ["${concat(list(aws_security_group.loadbalancer.id,
                                    aws_security_group.cluster.id),
                               var.ecs_additional_allowed_sg_ids)}"]

  user_data                   = "${module.user_data_ecs.rendered}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  enable_monitoring           = "${var.enable_monitoring}"
  ebs_optimized               = "${var.ebs_optimized}"

  lifecycle {
    create_before_destroy = true
  }
}
