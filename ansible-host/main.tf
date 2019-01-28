provider "aws" {
	profile		= "dazn-test"
 	region = "${terraform.workspace}"
}

variable "images" {
	type		= "map"
	default = {
	  "us-west-1" 		= "ami-4826c22b"
	  "ap-southeast-1" 	= "ami-8e0205f2"
	  "ap-northeast-1"	= "ami-8e8847f1"
	  "ca-central-1"	= "ami-e802818c"
	  "eu-central-1"	= "ami-dd3c0f36"
	  "eu-west-3"		= "ami-262e9f5b"
	  "sa-east-1"		= "ami-cb5803a7"
	}
}

variable "keys" {
        type            = "map"
        default = {
          "us-west-1"           = "aws-dazntest-n.california"
          "ap-southeast-1"      = "aws-dazn-test-singapore"
          "ap-northeast-1"      = "dazn-test-tokyo-syseng"
          "ca-central-1"        = "DAZN-trish"
          "eu-central-1"        = "dazntest_frankfurt_syseng"
	  "eu-west-3"		= "dazntest-paris-keypair"
          "sa-east-1"           = "DAZNTEST_SaoPaulo_keypair"
	}
}

resource "aws_security_group" "Ansible_SSH_Access" {
        name            = "ANSIBLE-SSH-ACCESS"
        description     = "Ansible SSH access SG"

        # allow traffic to SSH port
        ingress {
                from_port       = 22
                to_port         = 22
                protocol        = "tcp"
                cidr_blocks     = ["62.253.83.190/32", "82.11.218.115/32", "82.25.7.144/32"]
        }

        egress {
                from_port       = 0
                to_port         = 0
                protocol        = "-1"
                cidr_blocks     = ["0.0.0.0/0"]
        }

        tags {
                Name = "Ansible Host SSH Access SG"

        }
}

resource "aws_instance" "Proxy_Ansible_Host" {
	ami		= "${var.images["${terraform.workspace}"]}"
	key_name	= "${var.keys["${terraform.workspace}"]}"
	instance_type	= "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.Ansible_SSH_Access.id}"]
	user_data = <<-EOF
	#!/bin/bash
	sudo su -
	ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2QdIEjlrYnWri4+YgQJ8O82FGEWOTtdf/3iZBGmjR6uo8xUrIE9iZhH3OSLITmjQC1LDzRmaVctHVYl7hbmzFWJTgEsVO2q+QXbout+yAEx8C5XUg1YdZSDjbnkCe0AA1qGz3KWIudpCDZGRov/kkIL32ZF+PXiDbqaYN7p3su8QrYfHTqo9B9PhYS2FaununIYMDAkOaWAORidzU8kzYzFIjFiUZTNVH8oIyM+PkLc+rsRRLVONRU00HWoXrzEo1tLPxeVpn/81iPjYrGO5K2MKmqeDYR5OIgAu8deZ7n/xLiZl5qYrtEA2/K46fDZTOzEAOE1SrRzfcvVnLg4Rn trishulshah@Trishs-MacBook-Pro.local" >> /root/.ssh/authorized_keys
	yum -y install centos-release-scl
	yum -y install rh-python36
	echo "scl enable rh-python36 bash" >> /etc/profile
	scl enable rh-python36 bash
	/opt/rh/rh-python36/root/usr/bin/pip install --upgrade pip
	/opt/rh/rh-python36/root/usr/bin/pip install boto
	/opt/rh/rh-python36/root/usr/bin/pip install ansible
	mkdir /etc/ansible
	curl https://raw.githubusercontent.com/tshah-1/terraform/master/ansible-host/ec2.ini -o /etc/ansible/ec2.ini
	curl https://raw.githubusercontent.com/tshah-1/terraform/master/ansible-host/ec2.py -o /etc/ansible/ec2.py
	curl https://raw.githubusercontent.com/tshah-1/terraform/master/ansible-host/endpoints.json -o /opt/rh/rh-python36/root/usr/lib/python3.6/site-packages/boto/endpoints.json
	#mv ec2* /etc/ansible
	#mv endpoints.json  /opt/rh/rh-python36/root/usr/lib/python3.6/site-packages/boto/endpoints.json
	EOF
	tags {
		Name	= "Proxy_Ansible_Host"
	}
}

resource "aws_eip" "ansible_host_ip" {
	instance 	= "${aws_instance.Proxy_Ansible_Host.id}"
}
