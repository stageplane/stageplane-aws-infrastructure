# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#


terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws        = { source = "hashicorp/aws", version = ">= 6.28, < 7.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.32, < 4.0" }
    helm       = { source = "hashicorp/helm", version = ">= 2.14.0, < 3.0.0" }
  }
}
