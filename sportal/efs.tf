resource "aws_efs_file_system" "sportal-web" {
  creation_token                  = "sportalweb"
  performance_mode                = "generalPurpose"
  throughput_mode                 = "bursting"
#  provisioned_throughput_in_mibps = "256"
  encrypted                       = "true"

  tags = {
    Name        = "Sportal_web_EFS"
    Application = "sportal"
  }
}

resource "aws_route53_record" "efs-web" {
  // same number of records as instances
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "efs-web"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_efs_file_system.sportal-web.dns_name}"]
}

resource "aws_efs_mount_target" "sportal-web-efs-mount-a" {
  file_system_id  = "${aws_efs_file_system.sportal-web.id}"
  subnet_id       = "${aws_subnet.sportal_web_efs_a.id}"
  security_groups = ["${aws_security_group.sportal_web_efs.id}"]
}

resource "aws_efs_mount_target" "sportal-web-efs-mount-b" {
  file_system_id  = "${aws_efs_file_system.sportal-web.id}"
  subnet_id       = "${aws_subnet.sportal_web_efs_b.id}"
  security_groups = ["${aws_security_group.sportal_web_efs.id}"]
}

resource "aws_efs_mount_target" "sportal-web-efs-mount-c" {
  file_system_id  = "${aws_efs_file_system.sportal-web.id}"
  subnet_id       = "${aws_subnet.sportal_web_efs_c.id}"
  security_groups = ["${aws_security_group.sportal_web_efs.id}"]
}

resource "aws_efs_file_system" "sportal-web2" {
  creation_token   = "sportalweb2"
  performance_mode = "maxIO"
  throughput_mode  = "bursting"
  encrypted        = "false"

  tags = {
    Name        = "Sportal_web_EFS2"
    Application = "sportal"
  }
}

resource "aws_route53_record" "efs-web2" {
  // same number of records as instances
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "efs-web2"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_efs_file_system.sportal-web2.dns_name}"]
}

resource "aws_efs_mount_target" "sportal-web-efs2-mount-a" {
  file_system_id  = "${aws_efs_file_system.sportal-web2.id}"
  subnet_id       = "${aws_subnet.sportal_web_efs_a.id}"
  security_groups = ["${aws_security_group.sportal_web_efs.id}"]
}

resource "aws_efs_mount_target" "sportal-web-efs2-mount-b" {
  file_system_id  = "${aws_efs_file_system.sportal-web2.id}"
  subnet_id       = "${aws_subnet.sportal_web_efs_b.id}"
  security_groups = ["${aws_security_group.sportal_web_efs.id}"]
}

resource "aws_efs_mount_target" "sportal-web-efs2-mount-c" {
  file_system_id  = "${aws_efs_file_system.sportal-web2.id}"
  subnet_id       = "${aws_subnet.sportal_web_efs_c.id}"
  security_groups = ["${aws_security_group.sportal_web_efs.id}"]
}

resource "aws_efs_file_system" "sportal-cms" {
  creation_token   = "sportalcms"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = {
    Name        = "Sportal_cms_EFS"
    Application = "sportal"
  }
}

resource "aws_route53_record" "efs-cms" {
  // same number of records as instances
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "efs-cms"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_efs_file_system.sportal-cms.dns_name}"]
}

resource "aws_efs_mount_target" "sportal-cms-efs-mount-a" {
  file_system_id  = "${aws_efs_file_system.sportal-cms.id}"
  subnet_id       = "${aws_subnet.sportal_cms_efs_a.id}"
  security_groups = ["${aws_security_group.sportal_cms_efs.id}"]
}

resource "aws_efs_mount_target" "sportal-cms-efs-mount-b" {
  file_system_id  = "${aws_efs_file_system.sportal-cms.id}"
  subnet_id       = "${aws_subnet.sportal_cms_efs_b.id}"
  security_groups = ["${aws_security_group.sportal_cms_efs.id}"]
}

resource "aws_efs_mount_target" "sportal-cms-efs-mount-c" {
  file_system_id  = "${aws_efs_file_system.sportal-cms.id}"
  subnet_id       = "${aws_subnet.sportal_cms_efs_c.id}"
  security_groups = ["${aws_security_group.sportal_cms_efs.id}"]
}
