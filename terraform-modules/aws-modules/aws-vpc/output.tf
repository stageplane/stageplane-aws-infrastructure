# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file defines the output contract for the module. Outputs should expose
# only deliberate integration points for downstream stages and modules.
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "Identifier of the created VPC."
  value       = module.upstream_vpc.vpc_id
  sensitive   = true
}

output "private_subnet_ids" {
  description = "Identifiers of the private subnets created by the upstream VPC module."
  value       = module.upstream_vpc.private_subnets
  sensitive   = true
}

output "public_subnet_ids" {
  description = "Identifiers of the public subnets created by the upstream VPC module."
  value       = module.upstream_vpc.public_subnets
  sensitive   = true
}
