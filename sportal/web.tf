resource "aws_instance" "csportal-web" {
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
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAgD6qcLkoB7uDI5A24f6u/DZB9OhAXYyRhbAW4sVrud+WPgPraJFlgOymtEV39Hz0Ep/LVIRc6fu9RJz7zadL31EmBkcj4+ExZM4rkPF4UtyVaVf2ClhEefDXvr4EQ0Q24sXRKggVp4yzRg3jOyWfkvx/bPBWKPbVmZu3BFEljZi7EnwV2Ilpgqluk6+fXZKTeb7jqDeyKl3Zt9vIq3QxYLMkUqv4gNS9djoVVY0GcGLSIsQWN0TYmS85WhhId43yIuBn0Fgqyx+vzq6O92J74mMuRkWng3mcwe3MqYk60B/xm9OTBrM9V1NeH5urZ1RnTX1j1ZvbRadL7mDZ/LFpYQ== rsa-key-20190221" >> /root/.ssh/authorized_keys
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEA8eE730SS36/zDOGa8lRGV2Hu4e3Y/VL7Bv4j/z54z/xFi+foLfoP0ulcJVbvE6sjCld+cXktQ+RkDTrefrVJQFkgxDOJJ27PfR36MHaihZ1IxqOYN86n6gBH1/QVnm38KQ65bAL30oko1mTiYvkAFhO5Po9m1Sya5fRvAxqMExE= rsa-key-20140415" >> /root/.ssh/authorized_keys
        EOF
        tags {
                Name		= "${format("csportal-web%02d",count.index+1)}"
        }
}
