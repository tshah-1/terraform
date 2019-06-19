variable "num_instances_che_aza" {
  default = 0
}

variable "num_instances_che_azb" {
  default = 0
}

variable "num_instances_che_azc" {
  default = 0
}

resource "aws_instance" "csportal-che-aza" {
  ami      = "ami-06f428e6d06b4196d"
  key_name = "${var.keys["${terraform.workspace}"]}"

  # instance_type               = "r5a.2xlarge"
  instance_type               = "t3.small"
  vpc_security_group_ids      = ["${aws_security_group.sportal_web.id}"]
  subnet_id                   = "${aws_subnet.webfe_subnet_a.id}"
  count                       = "${var.num_instances_che_aza}"
  associate_public_ip_address = "true"

  tags {
    Name = "${format("csportal-che-a%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-che-aza" {
  // same number of records as instances
  count   = "${var.num_instances_che_aza}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-che-a%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-che-aza.*.private_ip, count.index)}"]
}

resource "aws_instance" "csportal-che-azb" {
  ami                         = "ami-06f428e6d06b4196d"
  key_name                    = "${var.keys["${terraform.workspace}"]}"
  instance_type               = "t3.small"
  vpc_security_group_ids      = ["${aws_security_group.sportal_web.id}"]
  subnet_id                   = "${aws_subnet.webfe_subnet_b.id}"
  count                       = "${var.num_instances_che_azb}"
  associate_public_ip_address = "true"

  tags {
    Name = "${format("csportal-che-b%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-che-azb" {
  // same number of records as instances
  count   = "${var.num_instances_che_azb}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-che-b%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-che-azb.*.private_ip, count.index)}"]
}

resource "aws_instance" "csportal-che-azc" {
  ami                         = "ami-06f428e6d06b4196d"
  key_name                    = "${var.keys["${terraform.workspace}"]}"
  instance_type               = "t3.small"
  vpc_security_group_ids      = ["${aws_security_group.sportal_web.id}"]
  subnet_id                   = "${aws_subnet.webfe_subnet_c.id}"
  count                       = "${var.num_instances_che_azc}"
  associate_public_ip_address = "true"

  tags {
    Name = "${format("csportal-che-c%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-che-azc" {
  // same number of records as instances
  count   = "${var.num_instances_che_azc}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-che-c%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-che-azc.*.private_ip, count.index)}"]
}
