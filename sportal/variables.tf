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
