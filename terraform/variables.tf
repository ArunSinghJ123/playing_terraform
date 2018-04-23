variable "key_name"
{
  description = "Desired name of AWS key pair"
  default = "terraform"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_vpc" {
  description = "AWS VPC Name."
  default     = "VPC ID GOES HERE"
}

variable "aws_subnet" {
  description = "AWS Subnet Name."
  default     = "SUBNET NAME GOES HERE"
}

variable "aws_security_group" {
  description = "AWS SG Name."
  default     = "SG GOES HERE"
}

variable "aws_ami" {
  default = {
    us-east-1 = "AMI ID GOES HERE"
  }
}
