provider "aws" {
        profile         = "${var.profile}"
        region          = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

data "external" "cloudfront_ip_ranges" {
  program = ["bash", "fetch-cloudfront-ips.sh"]
}

locals {
  cloudfront_ips      = ["${split("\n", data.external.cloudfront_ip_ranges.result.cloudfront_ips)}"]
  cloudfront_sg_count = "${ceil((length(local.cloudfront_ips) * 1.0) / 50)}"
}

resource "aws_security_group" "cloudfront" {
  name        = "cloudfront-security-group-${count.index + 1}"
  description = "Cloudfront Security Group"
  vpc_id      = "${aws_vpc.main.id}"
  count       = "${local.cloudfront_sg_count}"

  # allow all traffic from cloudfront ip ranges
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = 6
    cidr_blocks = ["${slice(local.cloudfront_ips, (count.index * 50), min((count.index * 50) + 50, length(local.cloudfront_ips)))}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Cloudfront SG ${count.index + 1}"
  }
}
