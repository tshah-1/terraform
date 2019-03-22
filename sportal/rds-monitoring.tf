resource "aws_rds_cluster" "ops-monitoring-cluster" {

    cluster_identifier            = "ops-monitoring-cluster"
    engine                        = "aurora"
    engine_mode                   = "serverless"
    scaling_configuration {
      auto_pause                  = false
      max_capacity                = 64
      min_capacity                = 2
    }
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    vpc_security_group_ids        = ["${aws_security_group.ops_monitoring_db.id}"]
    deletion_protection           = "true"
    backup_retention_period       = 14
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "mon:03:00-mon:04:00"
    db_subnet_group_name          = "${aws_db_subnet_group.sportal_subnet_group.name}"
    final_snapshot_identifier     = "ops-monitoring-cluster"

    tags {
        Name                      = "ops-monitoring-Aurora-DB-Cluster"
        ManagedBy                 = "terraform"
        Environment               = "ops-monitoring"
	Application                   = "sportal"
    }

    lifecycle {
        create_before_destroy     = true
    }
}

resource "aws_route53_record" "ops-monitoring-db" {
  zone_id                         = "${aws_route53_zone.sportal.zone_id}"
  name                            = "opsmonitoringdb"
  type                            = "CNAME"
  ttl                             = "300"
  records                         = ["${aws_rds_cluster.ops-monitoring-cluster.endpoint}"]
}
