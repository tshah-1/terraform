variable "num_instances_webserver_aza" {
  default = 1
}

variable "num_instances_webserver_azb" {
  default = 1
}

variable "num_instances_webserver_azc" {
  default = 1
}

resource "aws_instance" "csportal-webserver-aza" {
  ami                         = "ami-0a5961bd05f850aa9"
  key_name                    = "${var.keys["${terraform.workspace}"]}"
  instance_type               = "t3.medium"
  vpc_security_group_ids      = ["${aws_security_group.sportal_web.id}"]
  subnet_id                   = "${aws_subnet.webfe_subnet_a.id}"
  count                       = "${var.num_instances_webserver_aza}"
  associate_public_ip_address = "true"

  tags {
    Name = "${format("csportal-webserver-a%02d",count.index+1)}"
    Role = "webserver"
  }
}

resource "aws_route53_record" "csportal-webserver-aza" {
  // same number of records as instances
  count   = "${var.num_instances_webserver_aza}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-webserver-a%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-webserver-aza.*.private_ip, count.index)}"]
}

resource "aws_instance" "csportal-webserver-azb" {
  ami                         = "ami-0a5961bd05f850aa9"
  key_name                    = "${var.keys["${terraform.workspace}"]}"
  instance_type               = "t3.medium"
  vpc_security_group_ids      = ["${aws_security_group.sportal_web.id}"]
  subnet_id                   = "${aws_subnet.webfe_subnet_b.id}"
  count                       = "${var.num_instances_webserver_azb}"
  associate_public_ip_address = "true"

  tags {
    Name = "${format("csportal-webserver-b%02d",count.index+1)}"
    Role = "webserver"
  }
}

resource "aws_route53_record" "csportal-webserver-azb" {
  // same number of records as instances
  count   = "${var.num_instances_webserver_azb}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-webserver-b%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-webserver-azb.*.private_ip, count.index)}"]
}

resource "aws_instance" "csportal-webserver-azc" {
  ami                         = "ami-0a5961bd05f850aa9"
  key_name                    = "${var.keys["${terraform.workspace}"]}"
  instance_type               = "t3.medium"
  vpc_security_group_ids      = ["${aws_security_group.sportal_web.id}"]
  subnet_id                   = "${aws_subnet.webfe_subnet_c.id}"
  count                       = "${var.num_instances_webserver_azc}"
  associate_public_ip_address = "true"

  tags {
    Name = "${format("csportal-webserver-c%02d",count.index+1)}"
    Role = "webserver"
  }
}

resource "aws_route53_record" "csportal-webserver-azc" {
  // same number of records as instances
  count   = "${var.num_instances_webserver_azc}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-webserver-c%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-webserver-azc.*.private_ip, count.index)}"]
}
