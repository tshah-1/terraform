provider "aws" {
  profile = "${var.profile}"
  region  = "${terraform.workspace}"
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform.dynamo.lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

terraform {
  backend "s3" {
    bucket         = "sportal-terraform-state-v1"
    key            = "sportal-terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    profile        = "sportal"
    dynamodb_table = "terraform.dynamo.lock"
  }
}
