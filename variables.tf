variable "name" {
  description = "name of security group"
}

variable "sg_inbound" {
  description = "inbound fdefault allows"
  type        = any
  default     = []
}

variable "sg_inbound_self" {
  description = "self referencing rules"
  type        =  any
  default     =  []
}

variable "sg_outbound" {
  description = "outbound default allows"
  type        = any
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "map of tags for all resources"
  default     = {}
}

variable "vpc_id" {
}

