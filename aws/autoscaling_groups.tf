locals {
  asg_name = "${format("asg-%s", aws_launch_configuration.lc.name)}"
}

//
// The ECS cluser ASG
//
resource "aws_autoscaling_group" "asg" {
  count = "${var.enable ? 1 : 0}"
  name  = "${local.asg_name}"

  min_size         = "${var.asg_min_size}"
  max_size         = "${var.asg_max_size}"
  desired_capacity = "${var.desired_capacity}"

  vpc_zone_identifier  = ["${var.private_subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.lc.name}"

  health_check_grace_period = "${var.health_check_grace_period}"
  default_cooldown          = "${var.default_cooldown}"

  tag {
    key                 = "Name"
    value               = "${format("%s-asg", aws_ecs_cluster.cluster.name)}"
    propagate_at_launch = true
  }

  tag {
    key                 = "partner"
    value               = "${var.partner}"
    propagate_at_launch = true
  }

  tag {
    key                 = "system"
    value               = "${var.system}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "ECS"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = true
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  count                  = "${var.enable ? 1 : 0}"
  name                   = "${format("%s-scaleup", aws_autoscaling_group.asg.name)}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

resource "aws_autoscaling_policy" "scale_down" {
  count                  = "${var.enable ? 1 : 0}"
  name                   = "${format("%s-scaledown", aws_autoscaling_group.asg.name)}"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}
