variable "create_routable_app_sg" {
  description = "Controls if routable app sg's should be created (it affects almost all resources)"
  default     = true
}

variable "vpc_id" {
  description = "ID of Routable VPC to attach to the VPC"
  default     = ""
}

variable "vpc_cidr_block" {
  description = "CIDR block of Routable VPC to attach to the VPC"
  default     = ""
}

variable "urvpc_cidr_block" {
  description = "CIDR block of UnRoutable VPC to attach to the VPC"
  default     = ""
}

variable "internal_private" {
  description = "ID of UnRoutable VPC to attach to the VPC"
  default     = "10.0.0.0/8"
}
