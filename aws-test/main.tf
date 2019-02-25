provider "aws" {
  profile = "dazn-test"
  region  = "${var.region}"
}

variable "images" {
  type = "map"

  default = {
    "us-west-1"      = "ami-4826c22b"
    "ap-southeast-1" = "ami-8e0205f2"
    "ap-northeast-1" = "ami-8e8847f1"
    "ca-central-1"   = "ami-e802818c"
    "eu-central-1"   = "ami-dd3c0f36"
    "eu-west-3"      = "ami-262e9f5b"
    "sa-east-1"      = "ami-cb5803a7"
  }
}

variable "keys" {
  type = "map"

  default = {
    "us-west-1"      = "aws-dazntest-n.california"
    "ap-southeast-1" = "aws-dazn-test-singapore"
    "ap-northeast-1" = "dazn-test-tokyo-syseng"
    "ca-central-1"   = "DAZN-trish"
    "eu-central-1"   = "dazntest_frankfurt_syseng"
    "eu-west-3"      = "dazntest-paris-keypair"
    "sa-east-1"      = "DAZNTEST_SaoPaulo_keypair"
  }
}

data "external" "office_ip_ranges" {
  program = ["bash", "fetch-office-ips.sh"]
}

locals {
  office_ips      = ["${split("\n", data.external.office_ip_ranges.result.office_ips)}"]
  office_sg_count = "${ceil((length(local.office_ips) * 1.0) / 50)}"
}

resource "aws_security_group" "DAZN_Proxy_Squid_Access" {
  name        = "DAZN_PROXY_SQUID_SG-${count.index + 1}"
  description = "DAZN Proxy Squid Security Group"
  count       = "${local.office_sg_count}"

  # allow squid traffic from office ip ranges
  ingress {
    from_port   = 3128
    to_port     = 3128
    protocol    = 6
    cidr_blocks = ["${slice(local.office_ips, (count.index * 50), min((count.index * 50) + 50, length(local.office_ips)))}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "DAZN Proxy Squid SG ${count.index + 1}"
  }
}

resource "aws_security_group" "DAZN_Proxy_SSH_Access" {
  name        = "DAZN-PROXY-SSH-ACCESS"
  description = "DAZN proxy SSH access SG"

  # allow traffic to SSH port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["62.253.83.190/32", "82.11.218.115/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Dazn Proxy SSH Access SG"
  }
}

resource "aws_instance" "proxy_test" {
  ami                    = "${var.images}"
  key_name               = "${var.keys}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.DAZN_Proxy_SSH_Access.id}"]
  vpc_security_group_ids = ["${aws_security_group.DAZN_Proxy_Squid_Access.*.id}"]

  tags {
    Name = "dazn_proxy_test"
  }
}

resource "aws_eip" "dazn_proxy_ip" {
  instance = "${aws_instance.proxy_test.id}"
}
