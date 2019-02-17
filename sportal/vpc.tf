resource "aws_vpc" "main" {
	cidr_block 		= "172.24.0.0/20"
	enable_dns_support	= true
	enable_dns_hostnames	= true
	tags {
		Name		= "Sportal_VPC_DE"
        }
}

resource "aws_subnet" "public_subnet_a" {
	vpc_id			= "${aws_vpc.main.id}"
	cidr_block		= "172.24.0.0/24"
	availability_zone	= "eu-central-1a"

	tags {
		Name		= "Sportal_fe"
	}
}

resource "aws_subnet" "private_subnet_a" {
	vpc_id			= "${aws_vpc.main.id}"
	cidr_block		= "172.24.1.0/24"
	availability_zone	= "eu-central-1a"

	tags {
		Name		= "Sportal_be"
	}
}

resource "aws_internet_gateway" "main-ig" {
	vpc_id			= "${aws_vpc.main.id}"
	tags {
		Name		= "main IG"
	}
}

resource "aws_eip" "nat" {
	vpc			= true
}

resource "aws_nat_gateway" "nat" {
	allocation_id		= "${aws_eip.nat.id}"
	subnet_id		= "${aws_subnet.public_subnet_a.id}"
	tags {
		Name		= "main VPC NAT"
	}
}

resource "aws_route_table" "private_routetable" {
	vpc_id			= "${aws_vpc.main.id}"

	route {
		cidr_block	= "0.0.0.0/0"
		nat_gateway_id	= "${aws_nat_gateway.nat.id}"
	}

	tags {
		label 		= "Sportal"
	}
}

resource "aws_route_table_association" "private_subnet_a" {
	subnet_id		= "${aws_subnet.private_subnet_a.id}"
	route_table_id		= "${aws_route_table.private_routetable.id}"
}
