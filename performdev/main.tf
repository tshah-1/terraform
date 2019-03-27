provider "aws" {
  profile = "${var.profile}"
  region  = "${terraform.workspace}"
}

# create a dynamodb table for locking the state file
#resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#  name           = "terraform.dynamo.lock"
#  hash_key       = "LockID"
#  read_capacity  = 20
#  write_capacity = 20
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#
#  tags {
#    Name = "DynamoDB Terraform State Lock Table"
#  }
#}
#
#terraform {
#  backend "s3" {
#    bucket         = "performdev-terraform-state-v1"
#    key            = "performdev-terraform.tfstate"
#    region         = "eu-west-1"
#    encrypt        = true
#    profile        = "performdev"
#    dynamodb_table = "terraform.dynamo.lock"
#  }
#}
