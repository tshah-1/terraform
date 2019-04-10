variable "num_instances_che_aza" {
  default = 1
}

resource "aws_instance" "csportal-che-aza" {
  ami                         = "ami-044d6ea958a79824d"
  key_name                    = "${var.keys["${terraform.workspace}"]}"
  instance_type               = "r5a.2xlarge"
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
  count   = "${var.num_instances_web_aza}"
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "${format("csportal-che-a%02d",count.index+1)}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.csportal-che-aza.*.private_ip, count.index)}"]
}
