locals {
  description = "Private zone for ${var.zonename}"
}

resource "aws_route53_zone" "sportal" {
  name    = "${var.zonename}"
  vpc_id  = "${aws_vpc.main.id}"
  comment = "${local.description}"

  tags = {
    "Name"        = "${var.zonename}"
    "Application" = "${var.application}"
    "Description" = "${local.description}"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_vpc_dhcp_options" "sportal" {
  domain_name = "${var.zonename}"

  #        domain_name_servers     = ["ns-1536.awsdns-00.co.uk, ns-0.awsdns-00.com"]
}

resource "aws_vpc_dhcp_options_association" "sportal_dhcp_assoc" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.sportal.id}"
}
