resource "aws_vpc" "main" {
  cidr_block           = "172.24.0.0/23"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "Sportal_VPC_DE"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.0.0/24"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "Sportal_mgmt"
    application = "sportal"
    Tier        = "mgmt"
  }
}

resource "aws_subnet" "webfe_subnet_a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.1.0/28"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "sportal_webfe_a"
    application = "sportal"
    Tier        = "Webfe"
  }
}

resource "aws_subnet" "webfe_subnet_b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.1.16/28"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  availability_zone = "${terraform.workspace}b"

  tags {
    Name        = "sportal_webfe_b"
    application = "sportal"
    Tier        = "Webfe"
  }
}

resource "aws_subnet" "webfe_subnet_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.32/28"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  availability_zone = "${terraform.workspace}c"

  tags {
    Name        = "sportal_webfe_c"
    application = "sportal"
    Tier        = "Webfe"
  }
}

resource "aws_subnet" "cms_subnet_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.48/28"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "sportal_cms_a"
    application = "sportal"
    Tier        = "Cms"
  }
}

resource "aws_subnet" "cms_subnet_b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.64/28"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "sportal_cms_b"
    application = "sportal"
    Tier        = "Cms"
  }
}

resource "aws_subnet" "sportal_web_efs_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.80/28"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "sportal_web_efs_a"
    application = "sportal"
  }
}

resource "aws_subnet" "sportal_web_efs_b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.96/28"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "sportal_web_efs_b"
    application = "sportal"
  }
}

resource "aws_subnet" "sportal_web_efs_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.112/28"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "sportal_web_efs_c"
    application = "sportal"
  }
}

resource "aws_subnet" "sportal_cms_efs_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.128/28"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "sportal_cms_efs_a"
    application = "sportal"
  }
}

resource "aws_subnet" "sportal_cms_efs_b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.144/28"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "sportal_cms_efs_b"
    application = "sportal"
  }
}

resource "aws_subnet" "sportal_cms_efs_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.160/28"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "sportal_cms_efs_c"
    application = "sportal"
  }
}

resource "aws_internet_gateway" "main-ig" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "main IG"
    application = "sportal"
  }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-ig.id}"
  }

  tags {
    label = "Sportal"
  }
}

resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

resource "aws_route_table_association" "webfe_subnet_a" {
  subnet_id      = "${aws_subnet.webfe_subnet_a.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

resource "aws_route_table_association" "webfe_subnet_b" {
  subnet_id      = "${aws_subnet.webfe_subnet_b.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

resource "aws_route_table_association" "webfe_subnet_c" {
  subnet_id      = "${aws_subnet.webfe_subnet_c.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

resource "aws_route_table_association" "cms_subnet_a" {
  subnet_id      = "${aws_subnet.cms_subnet_a.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

resource "aws_route_table_association" "cms_subnet_b" {
  subnet_id      = "${aws_subnet.cms_subnet_b.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}
