variable "num_instances_cms" {
  default = 2
}

resource "aws_instance" "csportal-cms" {
  ami                    = "ami-0963f4d997fb2de41"
  key_name               = "sportal-frankfurt"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_cms.id}"]
  subnet_id              = "${aws_subnet.public_subnet_a.id}"
  count                  = "${var.num_instances_cms}"

  tags {
    Name = "${format("csportal-cms%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-cms" {
  // same number of records as instances
  count   = "${var.num_instances_cms}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-cms%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-cms.*.private_ip, count.index)}"]
}
