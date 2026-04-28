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

variable "cluster_name" {
  description = "Cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Cluster Kubernetes version."
  type        = string
}

variable "vpc_id" {
  description = "VPC identifier."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet identifiers."
  type        = list(string)
}


variable "node_groups" {
  description = <<-EOT
  Normalized StagePlane node groups rendered by stagectl.

  This is the authoritative StagePlane compute contract for EC2 and Fargate capacity.
  The controller expands mixed capacity before Terraform/OpenTofu receives this
  value. Fargate groups intentionally omit instance/scaling and instead define
  fargate.namespaces.
  EOT
  type = list(object({
    name = string
    role = string
    capacity = object({
      type    = string
      backend = optional(string, "managed_node_group")
      spot = optional(object({
        max_price            = optional(string, "")
        allocation_strategy  = optional(string, "")
        fallback_to_ondemand = optional(bool, false)
      }))
    })
    instance = optional(object({
      types    = list(string)
      ami_type = optional(string, "AL2023_x86_64_STANDARD")
    }))
    scaling = optional(object({
      desired = optional(number)
      min     = number
      max     = number
    }))
    fargate = optional(object({
      namespaces = list(string)
    }))
    labels = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))

  validation {
    condition = alltrue([
      for group in var.node_groups : contains(["on_demand", "spot", "fargate"], group.capacity.type)
    ])
    error_message = "Node groups must be pre-expanded to on_demand, spot, or fargate capacity. Mixed capacity must be expanded by stagectl before Terraform/OpenTofu runs."
  }

  validation {
    condition = alltrue([
      for group in var.node_groups :
      group.capacity.type == "fargate" ? try(length(group.fargate.namespaces) > 0, false) : try(length(group.instance.types) > 0 && group.scaling.min <= group.scaling.max, false)
    ])
    error_message = "Fargate groups require fargate.namespaces; EC2 groups require instance.types and valid scaling.min/scaling.max."
  }
}


variable "access_entry_arns" {
  description = "Principal ARNs optionally granted initial cluster access."
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Repository-standard tags."
  type        = map(string)
  default     = {}
}
