resource "aws_instance" "cspox-web" {
        ami             = "ami-01aeb888da1380a31"
        key_name        = "sportal-frankfurt"
        instance_type   = "t3.xlarge"
        vpc_security_group_ids = ["${aws_security_group.sportal_web.id}"]
	count = "8"
        user_data = <<-EOF
	#!/bin/bash
	echo "trish" >> /var/log/messages
	sudo su -
	echo "trishul" >> /var/log/messages
        #sudo su -
	yum -y update
        EOF
        tags {
                Name    = "${format("cspox-web%02d",count.index+1)}"
        }
}
