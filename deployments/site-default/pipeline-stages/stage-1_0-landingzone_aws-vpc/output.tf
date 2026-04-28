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
  description = "VPC identifier exported for downstream consumers such as Route53 and EKS."
  value       = module.landingzone_aws_vpc.vpc_id
  sensitive   = true
}

output "private_subnet_ids" {
  description = "Private subnet identifiers used by the EKS control plane and node groups."
  value       = module.landingzone_aws_vpc.private_subnet_ids
  sensitive   = true
}
