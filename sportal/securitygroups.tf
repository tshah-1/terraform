resource "aws_security_group" "sportal_web" {
	name			= "sportal_web"
        description		= "Sportal Web Server access SG"
        vpc_id                  = "${aws_vpc.main.id}"

        # allow traffic to HTTP port
	ingress {
		from_port       = 443
                to_port         = 443
                protocol        = "tcp"
                cidr_blocks     = ["0.0.0.0/0"]
        }

        ingress {
                from_port       = 80
                to_port         = 80
                protocol        = "tcp"
                cidr_blocks     = ["0.0.0.0/0"]
        }

        ingress {
                from_port       = 22
                to_port         = 22
                protocol        = "tcp"
                cidr_blocks     = ["${aws_eip.ansible_host_ip.public_ip}/32", "82.27.144.252/32"]
        }

        egress {
                from_port       = 0
                to_port         = 0
                protocol        = "-1"
                cidr_blocks     = ["0.0.0.0/0"]
        }

        tags {
                Name		= "Sportal Web SG"

        }
}

resource "aws_security_group" "sportal_efs" {
        name                    = "sportal_efs"
        description             = "Sportal Efs access SG"
        vpc_id                  = "${aws_vpc.main.id}"

	# allow NFS traffic 
	ingress {
		security_groups	= ["${aws_security_group.sportal_web.id}"]
                from_port       = 2049
                to_port         = 2049
                protocol        = "tcp"
        }
}

resource "aws_security_group" "Ansible_SSH_Access" {
        name                    = "ANSIBLE-SSH-ACCESS"
        description             = "Ansible SSH access SG"
        vpc_id                  = "${aws_vpc.main.id}"

        # allow traffic to SSH port
        ingress {
                from_port       = 22
                to_port         = 22
                protocol        = "tcp"
                cidr_blocks     = ["62.253.83.190/32", "82.11.218.115/32", "82.25.7.144/32", "82.27.144.252/32"]
        }

        egress {
                from_port       = 0
                to_port         = 0
                protocol        = "-1"
                cidr_blocks     = ["0.0.0.0/0"]
        }

        tags {
                Name            = "Ansible Host SSH Access SG"

        }
}
