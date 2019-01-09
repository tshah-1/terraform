provider "aws" {
	profile		= "${var.profile}"
	region		= "${var.region}"
}


resource "aws_instance" "proxy_test" {
	ami		= "ami-00846a67"
	instance_type	= "t2.micro"

	tags {
		Name 	= "dazn_proxy_test"
	}
}

data "external" "office_ip_ranges" {
  program 		= ["bash", "fetch-office-ips.sh"]
}

locals {
  office_ips      	= ["${split("\n", data.external.office_ip_ranges.result.office_ips)}"]
  office_sg_count 	= "${ceil((length(local.office_ips) * 1.0) / 50)}"
}

resource "aws_security_group" "DAZN_Proxy_Squid_Access" {
  name        		= "DAZN_PROXY_SQUID_SG-${count.index + 1}"
  description 		= "DAZN Proxy Squid Security Group"
  count       		= "${local.office_sg_count}"

  # allow all traffic from office ip ranges
  ingress {
    from_port   	= 3128
    to_port     	= 3128
    protocol    	= 6
    cidr_blocks 	= ["${slice(local.office_ips, (count.index * 50), min((count.index * 50) + 50, length(local.office_ips)))}"]
  }

  egress {
    from_port   	= 0
    to_port     	= 0
    protocol    	= "-1"
    cidr_blocks 	= ["0.0.0.0/0"]
  }

  tags {
    Name 		= "DAZN Proxy Squid SG ${count.index + 1}"
  }
}

resource "aws_security_group" "DAZN_Proxy_SSH_Access" {
        name            = "dazn-proxy-ssh-access"
        description     = "dazn proxy SSH access SG"

        # allow traffic to SSH port
        ingress {
                from_port       = 22
                to_port         = 22
                protocol        = "tcp"
                cidr_blocks     = ["62.253.83.190/32", "82.11.218.115/32"]
        }

        egress {
                from_port       = 0
                to_port         = 0
                protocol        = "-1"
                cidr_blocks     = ["0.0.0.0/0"]
        }

        tags {
                Name = "Dazn Proxy SSH Access SG"

        }
}
