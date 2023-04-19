variable "kube_subnets" {
  type        = list(string)
  description = "The image id to initiate"
}

variable "kube_sgs" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}