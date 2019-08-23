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
  instance_type          = "t3.xlarge"
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

resource "aws_eip" "csportal-cms-aza-eip" {
  instance = "${aws_instance.csportal-cms-aza.id}"
}
