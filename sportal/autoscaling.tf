resource "aws_launch_configuration" "web-launchconfig" {
  name_prefix     = "web-launchconfig"
  image_id        = "ami-044d6ea958a79824d"
  instance_type   = "t3.medium"
  key_name        = "${var.keys["${terraform.workspace}"]}"
  security_groups = ["${aws_security_group.sportal_web.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "allzones" {}

resource "aws_autoscaling_group" "web-autoscaling" {
  name                 = "web-autoscaling"
  vpc_zone_identifier  = ["${aws_subnet.webfe_subnet_a.id}", "${aws_subnet.webfe_subnet_b.id}", "${aws_subnet.webfe_subnet_c.id}"]
  launch_configuration = "${aws_launch_configuration.web-launchconfig.name}"
  availability_zones   = ["${data.aws_availability_zones.allzones.names}"]

  min_size                  = 3
  max_size                  = 15
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  enabled_metrics     = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  metrics_granularity = "1Minute"
  load_balancers      = ["${aws_elb.sportal_web_elb.id}", "${aws_elb.wintersport-kleinezeitung-at.id}", "${aws_elb.liveticker-sueddeutsche-de.id}", "${aws_elb.sportdaten-welt-de.id}", "${aws_elb.sportergebnisse-sueddeutsche.id}", "${aws_elb.welt-sportal-de.id}", "${aws_elb.liveticker-stern-de.id}", "${aws_elb.opta-sky-de.id}", "${aws_elb.20min-sportal-de.id}", "${aws_elb.kurier-sportal-de.id}", "${aws_elb.t-online-sportal-de.id}"]

  tags = {
    key                 = "Name"
    value               = "csportal-web"
    propagate_at_launch = true
  }
}

# scale up alarm
resource "aws_autoscaling_policy" "web-cpu-policy" {
  name                   = "web-cpu-policy"
  autoscaling_group_name = "${aws_autoscaling_group.web-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm" {
  alarm_name          = "web-cpu-alarm"
  alarm_description   = "web-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.web-autoscaling.name}"
  }

  actions_enabled   = true
  alarm_description = "This metric monitors EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.web-cpu-policy.arn}"]
}

# scale down alarm
resource "aws_autoscaling_policy" "web-cpu-policy-scaledown" {
  name                   = "web-cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.web-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm-scaledown" {
  alarm_name          = "web-cpu-alarm-scaledown"
  alarm_description   = "web-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.web-autoscaling.name}"
  }

  actions_enabled   = true
  alarm_description = "This metric monitors EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.web-cpu-policy-scaledown.arn}"]
}
