output "sportal_web_sg" {
  description = "Sportal Web Security Group"
  value       = "${aws_security_group.sportal_web.id}"
}

output "ansible_ip" {
  description = "Ansible Host Elastic IP"
  value       = "${aws_instance.Sportal_Ansible_Host.public_ip}"
}

output "dns_nameserver" {
  description = "name of private zone name servers"
  value       = "${aws_route53_zone.sportal.name_servers}"
}

output "openvpn_ip" {
  description = "OpenVPN Host Elastic IP"
  value       = "${aws_instance.openvpn.public_ip}"
}

output "efs_web_dns" {
  value = "${aws_efs_file_system.sportal-web.dns_name}"
}

output "efs_cms_dns" {
  value = "${aws_efs_file_system.sportal-cms.dns_name}"
}

output "db_cluster_address" {
  value = "${aws_rds_cluster.sportal-cluster.endpoint}"
}
