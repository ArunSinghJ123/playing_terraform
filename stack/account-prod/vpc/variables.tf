variable "publichostedzone" {
  description = "public zone name"
  default     = ""
}

variable "privatehostedzone" {
  description = "Private zone name"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "0.0.0.0/0"
}

variable "ur_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "0.0.0.0/0"
}

variable "ur_public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "ur_private_subnets" {
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

variable "create_peering" {
  description = "Controls the peering routes (it affects almost all resources)"
  default     = true
}
