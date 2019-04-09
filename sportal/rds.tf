resource "aws_rds_cluster" "sportal-cluster" {
  cluster_identifier = "${var.environment_name}-cluster"

  #   database_name                 = "mydb"
  engine      = "aurora"
  engine_mode = "serverless"

  scaling_configuration {
    auto_pause   = false
    max_capacity = 64
    min_capacity = 2
  }

  master_username              = "${var.rds_master_username}"
  master_password              = "${var.rds_master_password}"
  vpc_security_group_ids       = ["${aws_security_group.sportal_db.id}"]
  deletion_protection          = "true"
  backup_retention_period      = 14
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "mon:03:00-mon:04:00"
  db_subnet_group_name         = "${aws_db_subnet_group.sportal_subnet_group.name}"
  final_snapshot_identifier    = "${var.environment_name}-cluster"

  tags {
    Name        = "${var.environment_name}-Aurora-DB-Cluster"
    ManagedBy   = "terraform"
    Environment = "${var.environment_name}"
    Application = "sportal"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "sportal_subnet_group" {
  name        = "${var.environment_name}_aurora_db_subnet_group"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids  = ["${aws_subnet.db_subnet_a.id}", "${aws_subnet.db_subnet_b.id}", "${aws_subnet.db_subnet_c.id}"]

  tags {
    Name        = "${var.environment_name}-Aurora-DB-Subnet-Group"
    ManagedBy   = "terraform"
    Environment = "${var.environment_name}"
    Application = "sportal"
  }
}

resource "aws_route53_record" "sportal-db" {
  zone_id = "${aws_route53_zone.sportal.zone_id}"
  name    = "sportaldb"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_rds_cluster.sportal-cluster.endpoint}"]
}
