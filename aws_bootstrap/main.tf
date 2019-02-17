provider "aws" {
	profile		= "${var.profile}"
 	region		= "${terraform.workspace}"
}
