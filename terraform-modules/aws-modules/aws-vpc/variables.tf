# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file defines the input contract for the module. Variables must describe
# intent, ownership scope, notable constraints, and example cases where helpful.
# -----------------------------------------------------------------------------

variable "name" {
  description = <<-EOT
  Canonical VPC name.

  Example:
  - example-dev-us-west-2-vpc
  EOT
  type        = string
}

variable "cidr" {
  description = "Primary IPv4 CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones used by the landing zone."
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks aligned with the supplied availability zones."
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks aligned with the supplied availability zones."
  type        = list(string)
}

variable "enable_dns_hostnames" {
  description = "Whether EC2 private DNS hostnames are enabled in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether the Amazon-provided DNS resolver is enabled in the VPC."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Repository-standard tags applied to all supported resources."
  type        = map(string)
  default     = {}
}
