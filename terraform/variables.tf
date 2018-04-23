variable "key_name"
{
  description = "Desired name of AWS key pair"
  default = "terraform-sample"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_vpc" {
  description = "AWS VPC Name."
  default     = "vpc-47110a21"
}

variable "aws_subnet" {
  description = "AWS Subnet Name."
  default     = "subnet-20b6460c"
}

variable "aws_security_group" {
  description = "AWS SG Name."
  default     = "sg-f00373b9"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_ami" {
  default = {
    us-east-1 = "ami-1853ac65"
  }
}
