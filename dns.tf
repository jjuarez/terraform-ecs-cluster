resource "aws_route53_record" "lb" {
  count   = "${var.enable ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "${aws_ecs_cluster.cluster.name}"
  type    = "CNAME"
  ttl     = "${var.public_dns_ttl}"
  records = ["${aws_lb.lb.dns_name}"]
}
