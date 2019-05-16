resource "aws_alb" "sportal_alb" {
  name            = "sportal-alb"
  internal        = false
  security_groups = ["${aws_security_group.sportal_web_elb.id}", "${aws_security_group.sportal_web_apex_instance.id}"]
  subnets         = ["${aws_subnet.webelbfe_subnet_a.id}", "${aws_subnet.webelbfe_subnet_b.id}", "${aws_subnet.webelbfe_subnet_c.id}"]

  tags {
    name = "sportal-alb"
  }
}

resource "aws_alb_target_group" "sportal_alb_http" {
  name     = "sportal-alb-http"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "80"
  protocol = "HTTP"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "sportal_alb_be_http_aza" {
  target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "sportal_alb_be_http_azb" {
  target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "sportal_alb_be_http_azc" {
  target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 80
}

resource "aws_alb_target_group" "sportal_alb_https" {
  name     = "sportal-alb-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "sportal_alb_https_aza" {
  target_group_arn = "${aws_alb_target_group.sportal_alb_https.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 444
}

resource "aws_alb_target_group_attachment" "sportal_alb_https_azb" {
  target_group_arn = "${aws_alb_target_group.sportal_alb_https.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 444
}

resource "aws_alb_target_group_attachment" "sportal_alb_https_azc" {
  target_group_arn = "${aws_alb_target_group.sportal_alb_https.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 444
}

resource "aws_alb_listener" "sportal_alb_http" {
  load_balancer_arn = "${aws_alb.sportal_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "sportal_alb_https" {
  load_balancer_arn = "${aws_alb.sportal_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-central-1:884237813524:certificate/f20c9c28-58e0-4548-a022-ef7b54c05b4e"

  default_action {
    target_group_arn = "${aws_alb_target_group.sportal_alb_https.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "liveticker-sueddeutsche-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/fb8d7199-d1a0-4cdf-8320-53fe5744d4d9"
}

resource "aws_alb_target_group" "liveticker-sueddeutsche-de" {
  name     = "liveticker-sueddeutsche-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "liveticker-sueddeutsche-de-aza" {
  target_group_arn = "${aws_alb_target_group.liveticker-sueddeutsche-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 445
}

resource "aws_alb_target_group_attachment" "liveticker-sueddeutsche-de-azb" {
  target_group_arn = "${aws_alb_target_group.liveticker-sueddeutsche-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 445
}

resource "aws_alb_target_group_attachment" "liveticker-sueddeutsche-de-azc" {
  target_group_arn = "${aws_alb_target_group.liveticker-sueddeutsche-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 445
}

resource "aws_lb_listener_rule" "liveticker-sueddeutsche-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.liveticker-sueddeutsche-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.sueddeutsche.de"]
  }
}

resource "aws_lb_listener_rule" "liveticker-sueddeutsche-de-http" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.sueddeutsche.de"]
  }
}

##################################

resource "aws_lb_listener_certificate" "wsport-kleinezeitung" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/9494a276-d29e-413c-9375-043e75ed47d1"
}

resource "aws_alb_target_group" "wsport-kleinezeitung" {
  name     = "wsport-kleinezeitung-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "wsport-kleinezeitung-aza" {
  target_group_arn = "${aws_alb_target_group.wsport-kleinezeitung.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 444
}

resource "aws_alb_target_group_attachment" "wsport-kleinezeitung-azb" {
  target_group_arn = "${aws_alb_target_group.wsport-kleinezeitung.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 444
}

resource "aws_alb_target_group_attachment" "wsport-kleinezeitung-azc" {
  target_group_arn = "${aws_alb_target_group.wsport-kleinezeitung.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 444
}

resource "aws_lb_listener_rule" "wsport-kleinezeitung-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 97

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.wsport-kleinezeitung.arn}"
  }

  condition {
    field  = "host-header"
    values = ["wintersport.kleinezeitung.at"]
  }
}

resource "aws_lb_listener_rule" "wsport-kleinezeitung" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 96

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["wintersport.kleinezeitung.at"]
  }
}

#############################################

resource "aws_lb_listener_certificate" "sportdaten-welt-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/02732ca7-7ff2-45fe-8d26-cf84bb8696fa"
}

resource "aws_alb_target_group" "sportdaten-welt-de" {
  name     = "sportdaten-welt-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "sportdaten-welt-de-aza" {
  target_group_arn = "${aws_alb_target_group.sportdaten-welt-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 447
}

resource "aws_alb_target_group_attachment" "sportdaten-welt-de-azb" {
  target_group_arn = "${aws_alb_target_group.sportdaten-welt-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 447
}

resource "aws_alb_target_group_attachment" "sportdaten-welt-de-azc" {
  target_group_arn = "${aws_alb_target_group.sportdaten-welt-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 447
}

resource "aws_lb_listener_rule" "sportdaten-welt-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 95

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportdaten-welt-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["sportdaten.welt.de"]
  }
}

resource "aws_lb_listener_rule" "sportdaten-welt-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 94

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["sportdaten.welt.de"]
  }
}

##############################################

resource "aws_lb_listener_certificate" "sportergebnisse-sd" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/34ad5a5c-b350-4ba6-bee2-a1b42bd3333a"
}

resource "aws_alb_target_group" "sportergebnisse-sd" {
  name     = "sportergebnisse-sd-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "sportergebnisse-sd-aza" {
  target_group_arn = "${aws_alb_target_group.sportergebnisse-sd.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 446
}

resource "aws_alb_target_group_attachment" "sportergebnisse-sd-azb" {
  target_group_arn = "${aws_alb_target_group.sportergebnisse-sd.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 446
}

resource "aws_alb_target_group_attachment" "sportergebnisse-sd-azc" {
  target_group_arn = "${aws_alb_target_group.sportergebnisse-sd.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 446
}

resource "aws_lb_listener_rule" "sportergebnisse-sd-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 93

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportergebnisse-sd.arn}"
  }

  condition {
    field  = "host-header"
    values = ["sportergebnisse.sueddeutsche.de"]
  }
}

resource "aws_lb_listener_rule" "sportergebnisse-sd" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 92

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["sportergebnisse.sueddeutsche.de"]
  }
}

################################################

resource "aws_lb_listener_certificate" "welt-sportal-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/ca0a50e5-e9c5-4990-a5aa-6ab22f584184"
}

resource "aws_alb_target_group" "welt-sportal-de" {
  name     = "welt-sportal-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "welt-sportal-de-aza" {
  target_group_arn = "${aws_alb_target_group.welt-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 453
}

resource "aws_alb_target_group_attachment" "welt-sportal-de-azb" {
  target_group_arn = "${aws_alb_target_group.welt-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 453
}

resource "aws_alb_target_group_attachment" "welt-sportal-de-azc" {
  target_group_arn = "${aws_alb_target_group.welt-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 453
}

resource "aws_lb_listener_rule" "welt-sportal-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 91

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.welt-sportal-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["welt.sportal.de"]
  }
}

resource "aws_lb_listener_rule" "welt-sportal-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 90

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["welt.sportal.de"]
  }
}

################################

resource "aws_lb_listener_certificate" "liveticker-stern-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/d29a35f4-ab63-4c6c-8857-41c0d7565eb6"
}

resource "aws_alb_target_group" "liveticker-stern-de" {
  name     = "liveticker-stern-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "liveticker-stern-de-aza" {
  target_group_arn = "${aws_alb_target_group.liveticker-stern-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 448
}

resource "aws_alb_target_group_attachment" "liveticker-stern-de-azb" {
  target_group_arn = "${aws_alb_target_group.liveticker-stern-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 448
}

resource "aws_alb_target_group_attachment" "liveticker-stern-de-azc" {
  target_group_arn = "${aws_alb_target_group.liveticker-stern-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 448
}

resource "aws_lb_listener_rule" "liveticker-stern-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 89

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.liveticker-stern-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["liveticker.stern.de"]
  }
}

resource "aws_lb_listener_rule" "liveticker-stern-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 88

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["liveticker.stern.de"]
  }
}

####################################

resource "aws_lb_listener_certificate" "opta-sky-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:iam::884237813524:server-certificate/opta.sky.de"
}

resource "aws_alb_target_group" "opta-sky-de" {
  name     = "opta-sky-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "opta-sky-de-aza" {
  target_group_arn = "${aws_alb_target_group.opta-sky-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 448
}

resource "aws_alb_target_group_attachment" "opta-sky-de-azb" {
  target_group_arn = "${aws_alb_target_group.opta-sky-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 448
}

resource "aws_alb_target_group_attachment" "opta-sky-de-azc" {
  target_group_arn = "${aws_alb_target_group.opta-sky-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 448
}

resource "aws_lb_listener_rule" "opta-sky-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 87

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.opta-sky-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["opta.sky.de"]
  }
}

resource "aws_lb_listener_rule" "opta-sky-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 86

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["opta.sky.de"]
  }
}

###################################

resource "aws_lb_listener_certificate" "20min-sportal-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/fc6ac4bd-e117-4fb9-b57f-9ef43f43a340"
}

resource "aws_alb_target_group" "20min-sportal-de" {
  name     = "20min-sportal-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "20min-sportal-de-aza" {
  target_group_arn = "${aws_alb_target_group.20min-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 450
}

resource "aws_alb_target_group_attachment" "20min-sportal-de-azb" {
  target_group_arn = "${aws_alb_target_group.20min-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 450
}

resource "aws_alb_target_group_attachment" "20min-sportal-de-azc" {
  target_group_arn = "${aws_alb_target_group.20min-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 450
}

resource "aws_lb_listener_rule" "20min-sportal-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 85

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.20min-sportal-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["20min.sportal.de"]
  }
}

resource "aws_lb_listener_rule" "20min-sportal-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 84

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["20min.sportal.de"]
  }
}

####################################

resource "aws_lb_listener_certificate" "kurier-sportal-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/930f3e90-2003-4111-8348-cae11c2cd011"
}

resource "aws_alb_target_group" "kurier-sportal-de" {
  name     = "kurier-sportal-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "kurier-sportal-de-aza" {
  target_group_arn = "${aws_alb_target_group.kurier-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 451
}

resource "aws_alb_target_group_attachment" "kurier-sportal-de-azb" {
  target_group_arn = "${aws_alb_target_group.kurier-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 451
}

resource "aws_alb_target_group_attachment" "kurier-sportal-de-azc" {
  target_group_arn = "${aws_alb_target_group.kurier-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 451
}

resource "aws_lb_listener_rule" "kurier-sportal-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 83

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.kurier-sportal-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["kurier.sportal.de"]
  }
}

resource "aws_lb_listener_rule" "kurier-sportal-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 82

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["kurier.sportal.de"]
  }
}

#################################

resource "aws_lb_listener_certificate" "t-online-sportal-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/f20c9c28-58e0-4548-a022-ef7b54c05b4e"
}

resource "aws_alb_target_group" "t-online-sportal-de" {
  name     = "t-online-sportal-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "t-online-sportal-de-aza" {
  target_group_arn = "${aws_alb_target_group.t-online-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 452
}

resource "aws_alb_target_group_attachment" "t-online-sportal-de-azb" {
  target_group_arn = "${aws_alb_target_group.t-online-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 452
}

resource "aws_alb_target_group_attachment" "t-online-sportal-de-azc" {
  target_group_arn = "${aws_alb_target_group.t-online-sportal-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 452
}

resource "aws_lb_listener_rule" "t-online-sportal-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 81

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.t-online-sportal-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["t-online.sportal.de"]
  }
}

resource "aws_lb_listener_rule" "t-online-sportal-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 80

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["t-online.sportal.de"]
  }
}

####################################

resource "aws_lb_listener_certificate" "kicker-de" {
  listener_arn    = "${aws_alb_listener.sportal_alb_https.arn}"
  certificate_arn = "arn:aws:acm:eu-central-1:884237813524:certificate/ed48ede0-aaf3-43a7-a0f3-32ca246620c4"
}

resource "aws_alb_target_group" "kicker-de" {
  name     = "kicker-de-https"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "443"
  protocol = "HTTPS"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group_attachment" "kicker-de-aza" {
  target_group_arn = "${aws_alb_target_group.kicker-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-aza.id}"
  port             = 454
}

resource "aws_alb_target_group_attachment" "kicker-de-azb" {
  target_group_arn = "${aws_alb_target_group.kicker-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azb.id}"
  port             = 454
}

resource "aws_alb_target_group_attachment" "kicker-de-azc" {
  target_group_arn = "${aws_alb_target_group.kicker-de.arn}"
  target_id        = "${aws_instance.csportal-webserver-azc.id}"
  port             = 454
}

resource "aws_lb_listener_rule" "kicker-de-https" {
  listener_arn = "${aws_alb_listener.sportal_alb_https.arn}"
  priority     = 79

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.kicker-de.arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.kicker.de"]
  }
}

resource "aws_lb_listener_rule" "kicker-de" {
  listener_arn = "${aws_alb_listener.sportal_alb_http.arn}"
  priority     = 78

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.sportal_alb_http.arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.kicker.de"]
  }
}
