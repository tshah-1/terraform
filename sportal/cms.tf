variable "num_instances_cms" {
  default = 1
}

data "aws_subnet_ids" "cms" {
  vpc_id     = "${aws_vpc.main.id}"
  depends_on = ["aws_subnet.cms_subnet_a"]

  tags = {
    Name = "sportal_cms_*"
  }
}

resource "aws_instance" "csportal-cms-aza" {
  ami                    = "${var.images["${terraform.workspace}"]}"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.sportal_cms.id}"]
  subnet_id              = "${aws_subnet.cms_subnet_a.id}"
  count                  = "${var.num_instances_cms}"

  tags {
    Name = "${format("csportal-cms%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-cms-a" {
  // same number of records as instances
  count   = "${var.num_instances_cms}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-cms%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-cms-aza.*.private_ip, count.index)}"]
}

resource "aws_instance" "csportal-cms-azb" {
  ami                    = "${var.images["${terraform.workspace}"]}"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.sportal_cms.id}"]
  subnet_id              = "${aws_subnet.cms_subnet_b.id}"
  count                  = "${var.num_instances_cms}"

  tags {
    Name = "${format("csportal-cms%02d",count.index+2)}"
  }
}

resource "aws_route53_record" "csportal-cms-b" {
  // same number of records as instances
  count   = "${var.num_instances_cms}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-cms%02d",count.index+2)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-cms-azb.*.private_ip, count.index)}"]
}

resource "aws_elb" "sportal_cms_elb" {
  name            = "sportal-cms-elb"
  security_groups = ["${aws_security_group.sportal_cms_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.cms_subnet_a.id}", "${aws_subnet.cms_subnet_b.id}"]
  instances = ["${aws_instance.csportal-cms-aza.*.id}", "${aws_instance.csportal-cms-azb.*.id}"]

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

resource "aws_lb_cookie_stickiness_policy" "sportal_cms_elb_persistence" {
  name                     = "cms-cookie-persistence-policy"
  load_balancer            = "${aws_elb.sportal_cms_elb.id}"
  lb_port                  = 80
  cookie_expiration_period = 3600
}

resource "aws_eip" "csportal-cms-aza-eip" {
  instance = "${aws_instance.csportal-cms-aza.id}"
}

resource "aws_eip" "csportal-cms-azb-eip" {
  instance = "${aws_instance.csportal-cms-azb.id}"
}
