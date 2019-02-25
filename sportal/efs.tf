resource "aws_efs_file_system" "sportal" {
  creation_token   = "sportal"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = {
    Name = "SportalEFS"
  }
}

resource "aws_efs_mount_target" "sportal-efs-mount" {
  file_system_id  = "${aws_efs_file_system.sportal.id}"
  subnet_id       = "${aws_subnet.sportal_efs.id}"
  security_groups = ["${aws_security_group.sportal_efs.id}"]
}
