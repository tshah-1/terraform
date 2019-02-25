variable "num_instances" {
  default = 8
}

resource "aws_instance" "csportal-web" {
  ami                    = "ami-0963f4d997fb2de41"
  key_name               = "sportal-frankfurt"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.public_subnet_a.id}"
  count                  = "${var.num_instances}"

  tags {
    Name = "${format("csportal-web%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-web" {
  // same number of records as instances
  count   = "${var.num_instances}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-web%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-web.*.private_ip, count.index)}"]
}
