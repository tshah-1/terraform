variable "profile" {
  description = "AWS credentials profile you want to use"
}

variable "count" {
  default = 1
}

variable "zonename" {
  type        = "string"
  description = "Name of the hosted zone"
}

variable "application" {
  type        = "string"
  description = "Abbreviation of the product domain this Route 53 zone belongs to"
}

variable "secondary_vpcs" {
  type        = "list"
  default     = []
  description = "List of VPCs that will also be associated with this zone"
}

variable "images" {
  type = "map"

  default = {
    "us-west-1"      = "ami-4826c22b"
    "ap-southeast-1" = "ami-8e0205f2"
    "ap-northeast-1" = "ami-8e8847f1"
    "ca-central-1"   = "ami-e802818c"
    "eu-central-1"   = "ami-0963f4d997fb2de41"
    "eu-west-2"      = "ami-0eab3a90fc693af19"
    "sa-east-1"      = "ami-cb5803a7"
  }
}

variable "environment_name" {
    description = "The name of the environment"
}

variable "rds_master_username" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "rds_master_password" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}
