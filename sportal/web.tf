variable "num_instances_web" {
  default = 8
}

# Discover subnet IDs. This requires the subnetworks to be tagged with Tier = "webfe"
data "aws_subnet_ids" "webfe" {
  vpc_id = "${aws_vpc.main.id}"
  depends_on = ["aws_vpc.main"]
  tags {
    Name = "sportal_webfe*"
  }
}

# Discover subnets and create a list, one for each found ID
#data "aws_subnet" "web_tier" {
#  count = "${length(split(",", data.aws_subnet_ids.web_tier_ids.ids))}"
#  id = "${data.aws_subnet_ids.web_tier_ids.ids[count.index]}"
#}

# Discover subnet IDs. This requires the subnetworks to be tagged with Tier = "cms"
data "aws_subnet_ids" "cms" {
  vpc_id = "${aws_vpc.main.id}"
  depends_on = ["aws_vpc.main"]
  tags {
    Tier = "Cms"
  }
}

# Discover subnets and create a list, one for each found ID
#data "aws_subnet" "cms_tier" {
#  count = "${length(data.aws_subnet_ids.cms_tier_ids.ids)}"
#  id = "${data.aws_subnet_ids.cms_tier_ids.ids[count.index]}"
#}


resource "aws_instance" "csportal-web" {
  ami                    = "ami-0eab3a90fc693af19"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t3.xlarge"
  vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
  subnet_id              = "${element(data.aws_subnet_ids.webfe.ids, count.index)}"
#  subnet_id              = "${element(data.aws_subnet_ids.webfe.ids, count.index)}"
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
  subnets   = ["${aws_subnet.webfe_subnet_a.id}", "${aws_subnet.webfe_subnet_b.id}", "${aws_subnet.webfe_subnet_c.id}"]
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
