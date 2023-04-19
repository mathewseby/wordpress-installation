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

variable "instance_key_name" {
  type        = string
  description = "The image id to initiate"
}

variable "subnet" {
  type        = string
  description = "The image id to initiate"
}

variable "name" {
  type        = string
  description = "The image id to initiate"
  default     = "wpec2"
}

variable "vpc_id" {
  type        = string
  description = "The network ID to create DNS zone"
}

variable "internal_domain" {
  type        = string
  description = "The network ID to create DNS zone"
  default     = "mathewseby.local"
}

#variable "server_private_ip" {
#  type = list(string)
#}