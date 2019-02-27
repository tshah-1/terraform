resource "aws_vpc" "main" {
  cidr_block           = "172.24.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "Sportal_VPC_DE"
  }
}

variable "azs" {
  type = "map"

  default = {
    "us-west-1"      = "us-west-1a,us-west-1b,us-west-1c"
    "ap-southeast-1" = "ap-southeast-1a,ap-southeast-1b,ap-southeast-1c"
    "ap-northeast-1" = "ap-northeast-1a,ap-northeast-1bap-northeast-1c"
    "ca-central-1"   = "ca-central-1a,ca-central-1b,ca-central-1c"
    "eu-central-1"   = "eu-central-1a,eu-central-1b,eu-central-1c"
    "eu-west-3"      = "eu-west-3a,eu-west-3b,eu-west-3c"
    "eu-west-1"      = "eu-west-1a,eu-west-1b,eu-west-1b"
    "sa-east-1"      = "sa-east-1a,sa-east-1b,sa-east-1c"
    "eu-west-2"      = "eu-west-2a,eu-west-2b,eu-west-2c"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.0.0/24"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Sportal_mgmt"
    application = "sportal"
    Tier = "mgmt"
  }
}

resource "aws_subnet" "webfe_subnet_a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.0/27"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"

  tags {
    Name = "sportal_webfe_a"
    application = "sportal"
    Tier = "Webfe"
  }
}

resource "aws_subnet" "webfe_subnet_b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.32/27"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${terraform.workspace}b"

  tags {
    Name = "sportal_webfe_b"
    application = "sportal"
    Tier = "Webfe"
  }
}

resource "aws_subnet" "webfe_subnet_c" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.64/27"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"
  availability_zone       = "${terraform.workspace}c"

  tags {
    Name = "sportal_webfe_c"
    application = "sportal"
    Tier = "Webfe"
  }
}

resource "aws_subnet" "cms_subnet_a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.96/27"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index +1)}"

  tags {
    Name = "sportal_cms_a"
    application = "sportal"
    Tier = "Cms"
  }
}

resource "aws_subnet" "cms_subnet_b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.24.1.128/27"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"

  tags {
    Name = "sportal_cms_b"
    application = "sportal"
    Tier = "Cms"
  }
}


resource "aws_subnet" "sportal_web_efs" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.160/27"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index)}"

  tags {
    Name = "Sportal_web_efs"
    application = "sportal"
  }
}

resource "aws_subnet" "sportal_cms_efs" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.24.1.192/27"
  availability_zone       = "${element(split(",", lookup(var.azs, "${terraform.workspace}")), count.index+2)}"

  tags {
    Name = "Sportal_cms_efs"
    application = "sportal"
  }
}

resource "aws_internet_gateway" "main-ig" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main IG"
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
