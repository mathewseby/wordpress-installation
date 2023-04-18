variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "resource_type" {
  type        = string
  description = "The resource type of the bastion instance"
}

variable "instance_ami" {
  type        = string
  description = "The image id to initiate"
}