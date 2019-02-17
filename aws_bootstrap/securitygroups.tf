resource "aws_security_group" "sportal_web" {
	name			= "sportal_web"
        description		= "Sportal Web Server access SG"

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
                cidr_blocks     = ["82.27.144.252/32"]
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
