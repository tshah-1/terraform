resource "aws_launch_configuration" "web-launchconfig" {
  name_prefix     = "web-launchconfig"
  image_id        = "ami-0c17326b5ed5ed8ec"
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
  load_balancers      = ["${aws_elb.sportal_web_internal_elb.id}"]

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

resource "aws_elb" "sportal_web_internal_elb" {
  name            = "sportal-web-int-elb"
  security_groups = ["${aws_security_group.sportal_web_int_elb.id}"]
  internal = "true"
  subnets   = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 12
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
