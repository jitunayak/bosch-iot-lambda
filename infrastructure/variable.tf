variable "region" {
  default = "ap-south-1"
}

variable "aws_profile" {
  default = "default"
}

variable "shared_credentials_file" {
  description = "Profile file with credentials to the AWS account"
  type        = string
  default     = "~/.aws/credentials"
}

variable "tags" {
  type    = map(string)
  default = { application = "bosch_iot_lambda" }
}

variable "account_id" {
  type    = string
  default = "967217736102"
}

variable "stage_name" {
  type    = string
  default = "dev"
}

variable "table_name" {
  type    = string
  default = "IOT-DEVICE-DATA"
}
