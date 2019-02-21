variable "images" {
	type			= "map"
	default			= {
	  "us-west-1" 		= "ami-4826c22b"
	  "ap-southeast-1" 	= "ami-8e0205f2"
	  "ap-northeast-1"	= "ami-8e8847f1"
	  "ca-central-1"	= "ami-e802818c"
	  "eu-central-1"	= "ami-01aeb888da1380a31"
	  "eu-west-3"		= "ami-262e9f5b"
	  "sa-east-1"		= "ami-cb5803a7"
	}
}

variable "keys" {
        type			= "map"
        default			= {
          "us-west-1"           = "aws-dazntest-n.california"
          "ap-southeast-1"      = "aws-dazn-test-singapore"
          "ap-northeast-1"      = "dazn-test-tokyo-syseng"
          "ca-central-1"        = "DAZN-trish"
          "eu-central-1"        = "sportal-frankfurt"
	  "eu-west-3"		= "dazntest-paris-keypair"
          "sa-east-1"           = "DAZNTEST_SaoPaulo_keypair"
	}
}

resource "aws_instance" "Sportal_Ansible_Host" {
	ami			= "${var.images["${terraform.workspace}"]}"
	key_name		= "${var.keys["${terraform.workspace}"]}"
	instance_type		= "t2.micro"
	vpc_security_group_ids	= ["${aws_security_group.Ansible_SSH_Access.id}"]
	subnet_id		= "${aws_subnet.public_subnet_a.id}"
	user_data		= <<-EOF
	#!/bin/bash
	sudo su -
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
	yum -y install git
	EOF
	tags {
		Name		= "Sportal_Ansible_Host"
	}
}

resource "aws_eip" "ansible_host_ip" {
	instance 		= "${aws_instance.Sportal_Ansible_Host.id}"
}
