resource "aws_instance" "ops_monitoring" {
  ami                    = "ami-0a5f61c2d8cfc4bad"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t2.xlarge"
  vpc_security_group_ids = ["${aws_security_group.ops_monitoring.id}"]
  subnet_id              = "${aws_subnet.public_subnet_a.id}"
  count                  = "${var.num_instances_cms}"

  tags {
    Name = "${format("csportal-mon%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-mon" {
  // same number of records as instances
  count   = "${var.num_instances_cms}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-mon%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  records = ["${element(aws_instance.ops_monitoring.*.private_ip, count.index)}"]
}

resource "aws_eip" "ops_monitoring_ip" {
  instance = "${aws_instance.ops_monitoring.id}"
}
