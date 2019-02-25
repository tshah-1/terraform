provider "aws" {
  profile = "perform-content-master"
  region  = "${terraform.workspace}"
}

variable "keys" {
  type = "map"

  default = {
    "us-west-1"      = "aws-dazntest-n.california"
    "ap-southeast-1" = "aws-dazn-test-singapore"
    "ap-northeast-1" = "dazn-test-tokyo-syseng"
    "ca-central-1"   = "DAZN-trish"
    "eu-central-1"   = "dazntest_frankfurt_syseng"
    "eu-west-2"      = "infra-keypair-london"
    "sa-east-1"      = "DAZNTEST_SaoPaulo_keypair"
  }
}

resource "aws_security_group" "passwd_mgr_SG" {
  name        = "PASSWORD-MGR-SG"
  description = "Password Manager Security Group"

  # allow https traffic from office ip ranges
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = ["213.120.249.130/32", "82.25.7.144/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = 6
    cidr_blocks = ["213.120.249.130/32", "82.25.7.144/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = 6
    cidr_blocks = ["213.120.249.130/32", "82.25.7.144/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Password Manager SG"
  }
}

resource "aws_instance" "passwd_mgr" {
  ami                    = "ami-0eab3a90fc693af19"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.passwd_mgr_SG.id}"]

  user_data = <<-EOF
        #!/bin/bash
	sudo su -
	ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2QdIEjlrYnWri4+YgQJ8O82FGEWOTtdf/3iZBGmjR6uo8xUrIE9iZhH3OSLITmjQC1LDzRmaVctHVYl7hbmzFWJTgEsVO2q+QXbout+yAEx8C5XUg1YdZSDjbnkCe0AA1qGz3KWIudpCDZGRov/kkIL32ZF+PXiDbqaYN7p3su8QrYfHTqo9B9PhYS2FaununIYMDAkOaWAORidzU8kzYzFIjFiUZTNVH8oIyM+PkLc+rsRRLVONRU00HWoXrzEo1tLPxeVpn/81iPjYrGO5K2MKmqeDYR5OIgAu8deZ7n/xLiZl5qYrtEA2/K46fDZTOzEAOE1SrRzfcvVnLg4Rn trishulshah@Trishs-MacBook-Pro.local" >> /root/.ssh/authorized_keys
	chown root: /root/.ssh
	EOF

  tags {
    Name = "Perform_Password_Manager"
  }
}

resource "aws_eip" "passwd_mgr_eip" {
  instance = "${aws_instance.passwd_mgr.id}"

  tags {
    Name = "Perform_Password_Manager_SG"
  }
}
