variable "create_publiczone" {
  description = "Controls if Public Zone should be created (it affects almost all resources)"
  default     = false
}

variable "create_privatezone" {
  description = "Controls if Private Zone should be created (it affects almost all resources)"
  default     = false
}

variable "publichostedzone" {
  description = "public zone name"
  default     = ""
}

variable "privatehostedzone" {
  description = "Private zone name"
  default     = ""
}

variable "vpc_id" {
  description = "ID of Routable VPC to attach to the VPC"
  default     = ""
}

variable "urvpc_id" {
  description = "ID of UnRoutable VPC to attach to the VPC"
  default     = ""
}
