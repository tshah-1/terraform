provider "aws" {
	profile	= "${var.profile}"
	region	= "${var.region}"
}

resource "aws_instance" "proxy_test" {
	ami		= "ami-00846a67"
	instance_type	= "t2.micro"

	tags {
	 Name = "dazn_proxy_test"
	}
}
