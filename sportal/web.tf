variable "num_instances_web_aza" {
  default = 3
}
variable "num_instances_web_azb" {
  default = 3
}
variable "num_instances_web_azc" {
  default = 2
}

resource "aws_instance" "csportal-web-aza" {
  ami                    = "ami-0eab3a90fc693af19"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.webfe_subnet_a.id}"
  count                  = "${var.num_instances_web_aza}"

  tags {
    Name = "${format("csportal-web%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-web-aza" {
  // same number of records as instances
  count   = "${var.num_instances_web_aza}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-web%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"
  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-web-aza.*.private_ip, count.index)}"]
}

resource "aws_instance" "csportal-web-azb" {
  ami                    = "ami-0eab3a90fc693af19"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.webfe_subnet_b.id}"
  count                  = "${var.num_instances_web_azb}"

  tags {
    Name = "${format("csportal-web%02d",count.index+4)}"
  }
}

resource "aws_route53_record" "csportal-web-azb" {
  // same number of records as instances
  count   = "${var.num_instances_web_azb}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-web%02d",count.index+4)}"
  type    = "A"
  ttl     = "300"
  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-web-azb.*.private_ip, count.index)}"]
}

resource "aws_instance" "csportal-web-azc" {
  ami                    = "ami-0eab3a90fc693af19"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.webfe_subnet_c.id}"
  count                  = "${var.num_instances_web_azc}"

  tags {
    Name = "${format("csportal-web%02d",count.index+7)}"
  }
}

resource "aws_route53_record" "csportal-web-azc" {
  // same number of records as instances
  count   = "${var.num_instances_web_azc}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-web%02d",count.index+7)}"
  type    = "A"
  ttl     = "300"
  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-web-azc.*.private_ip, count.index)}"]
}

resource "aws_elb" "sportal_web_elb" {
  name            = "sportal-webelb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webfe_subnet_a.id}", "${aws_subnet.webfe_subnet_b.id}", "${aws_subnet.webfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

  #  listener {
  #    lb_port = 443
  #    lb_protocol = "https"
  #    instance_port = "443"
  #    instance_protocol = "https"
  #  }
}
