output "sportal_web_sg" {
	description	= "Sportal Web Security Group"
	value		= "${aws_security_group.sportal_web.id}"
}
