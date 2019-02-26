variable "num_instances_web" {
  default = 8
}

resource "aws_instance" "csportal-web" {
  ami                    = "ami-0963f4d997fb2de41"
  key_name               = "sportal-frankfurt"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${aws_subnet.public_subnet_a.id}"
  count                  = "${var.num_instances_web}"

  tags {
    Name = "${format("csportal-web%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-web" {
  // same number of records as instances
  count   = "${var.num_instances_web}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-web%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-web.*.private_ip, count.index)}"]
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "sportal_web_elb" {
  name            = "sportal-webelb"
  security_groups = ["${aws_security_group.sportal_web_elb.id}"]

  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  subnets   = ["${aws_subnet.public_subnet_a.id}"]
  instances = ["${element(aws_instance.csportal-web.*.id, count.index)}"]

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
