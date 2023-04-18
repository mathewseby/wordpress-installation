variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}