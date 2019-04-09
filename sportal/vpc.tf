resource "aws_vpc" "main" {
  cidr_block           = "172.24.0.0/20"
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
    Application = "sportal"
    Tier        = "mgmt"
  }
}

resource "aws_subnet" "webelbfe_subnet_a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.3.0/24"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_elbwebfe_a"
    Application = "sportal"
    Tier        = "Fe"
  }
}

resource "aws_subnet" "webelbfe_subnet_b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.4.0/24"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_elbwebfe_b"
    Application = "sportal"
    Tier        = "Fe"
  }
}

resource "aws_subnet" "webelbfe_subnet_c" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.5.0/24"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_elbwebfe_c"
    Application = "sportal"
    Tier        = "Fe"
  }
}

resource "aws_subnet" "webfe_subnet_a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.1.0/28"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_webfe_a"
    Application = "sportal"
    Tier        = "Webfe"
  }
}

resource "aws_subnet" "webfe_subnet_b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.24.1.16/28"

  #  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  availability_zone       = "${terraform.workspace}b"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_webfe_b"
    Application = "sportal"
    Tier        = "Webfe"
  }
}

resource "aws_subnet" "webfe_subnet_c" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.32/28"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  availability_zone       = "${terraform.workspace}c"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_webfe_c"
    Application = "sportal"
    Tier        = "Webfe"
  }
}

resource "aws_subnet" "cms_subnet_a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.48/28"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_cms_a"
    Application = "sportal"
    Tier        = "Cms"
  }
}

resource "aws_subnet" "cms_subnet_b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.64/28"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sportal_cms_b"
    Application = "sportal"
    Tier        = "Cms"
  }
}

resource "aws_subnet" "sportal_web_efs_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.80/28"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "sportal_web_efs_a"
    Application = "sportal"
  }
}

resource "aws_subnet" "sportal_web_efs_b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.96/28"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "sportal_web_efs_b"
    Application = "sportal"
  }
}

resource "aws_subnet" "sportal_web_efs_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.112/28"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "sportal_web_efs_c"
    Application = "sportal"
  }
}

resource "aws_subnet" "sportal_cms_efs_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.128/28"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "sportal_cms_efs_a"
    Application = "sportal"
  }
}

resource "aws_subnet" "sportal_cms_efs_b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.144/28"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "sportal_cms_efs_b"
    Application = "sportal"
  }
}

resource "aws_subnet" "sportal_cms_efs_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.160/28"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "sportal_cms_efs_c"
    Application = "sportal"
  }
}

resource "aws_internet_gateway" "main-ig" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "main IG"
    Application = "sportal"
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

resource "aws_route_table_association" "webelbfe_subnet_a" {
  subnet_id      = "${aws_subnet.webelbfe_subnet_a.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

resource "aws_route_table_association" "webelbfe_subnet_b" {
  subnet_id      = "${aws_subnet.webelbfe_subnet_b.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

resource "aws_route_table_association" "webelbfe_subnet_c" {
  subnet_id      = "${aws_subnet.webelbfe_subnet_c.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
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

resource "aws_eip" "main-nat" {
  vpc = true
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"

  tags {
    Name = "main VPC NAT"
  }
}

resource "aws_route_table" "private_routetable" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    label = "Sportal"
  }
}

resource "aws_subnet" "db_subnet_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.2.0/28"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "db_subnet_a"
    Application = "sportal"
  }
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.2.16/28"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "db_subnet_b"
    Application = "sportal"
  }
}

resource "aws_subnet" "db_subnet_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.2.32/28"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "db_subnet_c"
    Application = "sportal"
  }
}

resource "aws_route_table_association" "db_subnet_a" {
  subnet_id      = "${aws_subnet.db_subnet_a.id}"
  route_table_id = "${aws_route_table.private_routetable.id}"
}

resource "aws_route_table_association" "db_subnet_b" {
  subnet_id      = "${aws_subnet.db_subnet_b.id}"
  route_table_id = "${aws_route_table.private_routetable.id}"
}

resource "aws_route_table_association" "db_subnet_c" {
  subnet_id      = "${aws_subnet.db_subnet_c.id}"
  route_table_id = "${aws_route_table.private_routetable.id}"
}
