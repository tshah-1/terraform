provider "aws" {
  profile = "dazn-test"
  region  = "${terraform.workspace}"
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

variable "name" {
  type = "map"

  default = {
    "us-west-1"      = "DAZN-PROXY-US"
    "ap-southeast-1" = "DAZN-PROXY-SEA"
    "ap-northeast-1" = "DAZN-Proxy-Japan"
    "ca-central-1"   = "DAZN-Proxy-Canada"
    "eu-central-1"   = "DAZN-Proxy-DACH"
    "eu-west-3"      = "DAZN-PROXY-Italy"
    "sa-east-1"      = "DAZN-PROXY-Brazil"
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
    cidr_blocks = ["62.253.83.190/32", "35.181.19.212/32", "82.25.7.144/32"]
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

resource "aws_instance" "dazn_proxy" {
  ami                    = "${var.images["${terraform.workspace}"]}"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.DAZN_Proxy_SSH_Access.id}"]
  vpc_security_group_ids = ["${aws_security_group.DAZN_Proxy_Squid_Access.*.id}"]
  count                  = "${var.count}"

  user_data = <<-EOF
        #!/bin/bash
	sudo su -
	ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2QdIEjlrYnWri4+YgQJ8O82FGEWOTtdf/3iZBGmjR6uo8xUrIE9iZhH3OSLITmjQC1LDzRmaVctHVYl7hbmzFWJTgEsVO2q+QXbout+yAEx8C5XUg1YdZSDjbnkCe0AA1qGz3KWIudpCDZGRov/kkIL32ZF+PXiDbqaYN7p3su8QrYfHTqo9B9PhYS2FaununIYMDAkOaWAORidzU8kzYzFIjFiUZTNVH8oIyM+PkLc+rsRRLVONRU00HWoXrzEo1tLPxeVpn/81iPjYrGO5K2MKmqeDYR5OIgAu8deZ7n/xLiZl5qYrtEA2/K46fDZTOzEAOE1SrRzfcvVnLg4Rn trishulshah@Trishs-MacBook-Pro.local" >> /root/.ssh/authorized_keys
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEW4X7gY5NS5TTycNLcc5y/RPBrOXAdsJ3BOxcRDsq14rYr/zqOj+HksUy5L9rHIF2/zs+BYS3mPtEi1BtbcxytfJ55P4LgJBQlSnyF6c2E/Et9/J3cIlnXAAG+ZO065fum4r3ww1GQNueE4iW4NkDsZOcYh9QUsG5/iBqs1Oafxzuw2KPTSlDKit7LKQiMZhvcUBnh3BswgnI1hNMx8Hj2EwWTZ2YaJRTqEmczFMhbnw+ORdFyw9RUnlhKMUZac/P2ECW0BNBdk9wS4CvmeLTSZHkzZE9wWHSN3B5xopDKurttOP5et5Nxbvab3E9I03Xlq/2grn7TEwEmqNDP9Sl root@ip-172-31-32-210.eu-west-3.compute.internal" >> /root/.ssh/authorized_keys
	EOF

  tags {
    Name = "${var.name["${terraform.workspace}"]}${count.index+1}"
  }
}

resource "aws_eip" "dazn_proxy_ip" {
  instance = "${aws_instance.dazn_proxy.id}"
}
