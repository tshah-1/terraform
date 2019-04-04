variable "keys" {
  type = "map"

  default = {
    "us-west-1"      = "aws-dazntest-n.california"
    "ap-southeast-1" = "aws-dazn-test-singapore"
    "ap-northeast-1" = "dazn-test-tokyo-syseng"
    "ca-central-1"   = "DAZN-trish"
    "eu-central-1"   = "sportal-frankfurt"
    "eu-west-3"      = "dazntest-paris-keypair"
    "eu-west-2"      = "sportal-london"
    "sa-east-1"      = "DAZNTEST_SaoPaulo_keypair"
  }
}

resource "aws_instance" "Sportal_Ansible_Host" {
  ami                    = "${var.images["${terraform.workspace}"]}"
  key_name               = "${var.keys["${terraform.workspace}"]}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.Ansible_SSH_Access.id}"]
  subnet_id              = "${aws_subnet.public_subnet_a.id}"

  user_data = <<-EOF
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
    Name = "csportal-ansible"
  }
}

resource "aws_eip" "ansible_host_ip" {
  instance = "${aws_instance.Sportal_Ansible_Host.id}"
}

resource "aws_route53_record" "ansible-host" {
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "csportal-ansible"
  type    = "A"
  ttl     = "300"

  records = ["${aws_instance.Sportal_Ansible_Host.private_ip}"]
}
