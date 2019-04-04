resource "aws_instance" "openvpn" {
  ami                    = "ami-05c15237ad9de71f5"
  key_name               = "sportal-frankfurt"
  instance_type          = "t2.small"
  vpc_security_group_ids = ["${aws_security_group.openvpn.id}", "${aws_security_group.ops_monitoring_snmp_icmp}"]
  subnet_id              = "${aws_subnet.public_subnet_a.id}"

  tags {
    Name = "csportal-ovpn01"
  }
}

resource "aws_eip" "openvpn_eip" {
  instance = "${aws_instance.openvpn.id}"
}
