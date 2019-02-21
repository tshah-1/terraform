output "sportal_web_sg" {
	description	= "Sportal Web Security Group"
	value		= "${aws_security_group.sportal_web.id}"
}
output "ansible_ip" {
        description     = "Ansible Host Elastic IP"
        value           = "${aws_instance.Sportal_Ansible_Host.public_ip}"
}
