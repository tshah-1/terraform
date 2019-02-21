resource "aws_instance" "cspox-web" {
	ami			= "ami-01aeb888da1380a31"
        key_name		= "sportal-frankfurt"
        instance_type		= "t3.xlarge"
        vpc_security_group_ids	= ["${aws_security_group.sportal_web.id}"]
	subnet_id		= "${aws_subnet.public_subnet_a.id}"
	count			= "8"
        user_data		= <<-EOF
	#!/bin/bash
	sudo su -
        ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhZnRGfgEQkv3JBWqwQxEr0z3fe4acaq1H4WFWivcrUXvTL9I5pM8bb4SPOu/q7d859kFo5fTT9CqYz15i3XjbhPvPocPDTgvg1HPHGYriMS/zDiMTdrg2fnFNsbgeW74e3ZjiV4dbz6/Qqcr9dRDMr/Fp+QadwfkxfeOl93+5SgBhs1GUhgkD0LDdNFyShBiFZrPib37xQZWP83Do8CUtZio9lZtWh2s21B0/lBU6JYpZbZQwIhbReV2SpjIPiI5VnT9JhfMwnM4cyIVnsZcL7t1VVUUL+uQVYRwrxlBzAQ8lAJbjBmeV69WZxnWfYiEeY137Y8GxXNUxXXtMBVIb root@ip-172-31-43-200.eu-central-1.compute.internal" >> /root/.ssh/authorized_keys
        EOF
        tags {
                Name		= "${format("cspox-web%02d",count.index+1)}"
        }
}
