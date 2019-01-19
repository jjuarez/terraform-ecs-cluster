resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count               = "${var.enable ? 1 : 0}"
  alarm_name          = "${aws_ecs_cluster.cluster.name}-cpureservation-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.ecs_cpu_high_evaluation_periods}"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_cpu_high_period}"
  statistic           = "Maximum"
  threshold           = "${var.ecs_cpu_high_threshold}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_description = "Scale up if the cpu reservation is above 90% for 10 minutes"
  alarm_actions     = ["${aws_autoscaling_policy.scale_up.arn}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  count               = "${var.enable ? 1 : 0}"
  alarm_name          = "${aws_ecs_cluster.cluster.name}-memoryreservation-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.ecs_memory_high_evaluation_periods}"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_memory_high_period}"
  statistic           = "Maximum"
  threshold           = "${var.ecs_memory_high_threshold}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_description = "Scale up if the memory reservation is above 90% for 10 minutes"
  alarm_actions     = ["${aws_autoscaling_policy.scale_up.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_cloudwatch_metric_alarm.cpu_high"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count               = "${var.enable ? 1 : 0}"
  alarm_name          = "${aws_ecs_cluster.cluster.name}-cpureservation-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "${var.ecs_cpu_low_evaluation_periods}"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_cpu_low_period}"
  statistic           = "Maximum"
  threshold           = "${var.ecs_cpu_low_threshold}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_description = "Scale down if the cpu reservation is below 10% for 10 minutes"
  alarm_actions     = ["${aws_autoscaling_policy.scale_down.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_cloudwatch_metric_alarm.memory_high"]
}

resource "aws_cloudwatch_metric_alarm" "memory_low" {
  count               = "${var.enable ? 1 : 0}"
  alarm_name          = "${aws_ecs_cluster.cluster.name}-memoryreservation-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "${var.ecs_memory_low_evaluation_periods}"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_memory_low_period}"
  statistic           = "Maximum"
  threshold           = "${var.ecs_memory_low_threshold}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }

  alarm_description = "Scale down if the memory reservation is below 10% for 10 minutes"
  alarm_actions     = ["${aws_autoscaling_policy.scale_down.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_cloudwatch_metric_alarm.cpu_low"]
}
