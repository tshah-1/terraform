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
  ami                    = "${var.images["${terraform.workspace}"]}"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.webfe_subnet_a.id}"
  count                  = "${var.num_instances_web_aza}"
  associate_public_ip_address = "true"

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
  ami                    = "${var.images["${terraform.workspace}"]}"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.webfe_subnet_b.id}"
  count                  = "${var.num_instances_web_azb}"
  associate_public_ip_address = "true"

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
  ami                    = "${var.images["${terraform.workspace}"]}"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.webfe_subnet_c.id}"
  count                  = "${var.num_instances_web_azc}"
  associate_public_ip_address = "true"

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

resource "aws_elb" "wintersport-kleinezeitung-at" {
  name            = "wintersport-kleinezeitung-at-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:81/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "81"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "444"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/9494a276-d29e-413c-9375-043e75ed47d1"
    }
}

resource "aws_elb" "liveticker-sueddeutsche-de" {
  name            = "liveticker-sueddeutsche-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:82"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "82"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "445"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/fb8d7199-d1a0-4cdf-8320-53fe5744d4d9"
    }
}

resource "aws_elb" "sportdaten-welt-de" {
  name            = "sportdaten-welt-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:84"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "84"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "447"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/02732ca7-7ff2-45fe-8d26-cf84bb8696fa"
    }
}

resource "aws_elb" "sportergebnisse-sueddeutsche" {
  name            = "sportergebnisse-sueddeutsche-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:83"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "83"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "446"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/34ad5a5c-b350-4ba6-bee2-a1b42bd3333a"
    }
}

resource "aws_elb" "welt-sportal-de" {
  name            = "welt-sportal-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:90"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "90"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "453"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/ca0a50e5-e9c5-4990-a5aa-6ab22f584184"
    }
}

resource "aws_elb" "liveticker-stern-de" {
  name            = "liveticker-stern-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:85"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "85"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "448"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/d29a35f4-ab63-4c6c-8857-41c0d7565eb6"
    }
}

resource "aws_elb" "opta-sky-de" {
  name            = "opta-sky-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:86"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "86"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "449"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:iam::884237813524:server-certificate/opta.sky.de"
    }
}

resource "aws_elb" "20min-sportal-de" {
  name            = "20min-sportal-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:87"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "87"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "450"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/fc6ac4bd-e117-4fb9-b57f-9ef43f43a340"
    }
}

resource "aws_elb" "kurier-sportal-de" {
  name            = "kurier-sportal-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:88"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "88"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "451"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/930f3e90-2003-4111-8348-cae11c2cd011"
    }
}

resource "aws_elb" "t-online-sportal-de" {
  name            = "t-online-sportal-de-elb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]
  instances = ["${aws_instance.csportal-web-aza.*.id}", "${aws_instance.csportal-web-azb.*.id}", "${aws_instance.csportal-web-azc.*.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "TCP:89"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "89"
    instance_protocol = "http"
  }

    listener {
      lb_port = 443
      lb_protocol = "https"
      instance_port = "452"
      instance_protocol = "https"
      ssl_certificate_id = "arn:aws:acm:eu-central-1:884237813524:certificate/c1b5aeed-f249-4ea3-8a45-3cd2e8245a3f"
    }
}
