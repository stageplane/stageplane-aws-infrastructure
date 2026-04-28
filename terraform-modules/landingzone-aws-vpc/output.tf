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
  value       = module.aws_vpc.vpc_id
  sensitive   = true
}

output "private_subnet_ids" {
  description = "Private subnet identifiers intended for the EKS control plane and node groups."
  value       = module.aws_vpc.private_subnet_ids
  sensitive   = true
}

output "public_subnet_ids" {
  description = "Public subnet identifiers available for ingress-facing or utility components."
  value       = module.aws_vpc.public_subnet_ids
  sensitive   = true
}
