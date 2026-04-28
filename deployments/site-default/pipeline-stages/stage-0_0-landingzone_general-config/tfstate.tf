# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file creates the managed Terraform/OpenTofu state substrate for the AWS
# reference baseline. The resources intentionally live in stage-0_0 because this
# is the bootstrap boundary: the first stage runs with local state, publishes the
# backend contract, and later stages switch to controller-rendered remote state.
# -----------------------------------------------------------------------------

locals {
  backend_mode         = try(var.backend.mode, "managed")
  backend_type         = try(var.backend.type, "s3")
  backend_config       = try(var.backend.config, {})
  managed_s3_backend   = local.backend_mode == "managed" && local.backend_type == "s3"
  tf_state_bucket_name = try(local.backend_config.bucket, format("%s-%s-%s-%s-tfstate", var.company_name, var.platform_name, var.environment, var.aws_region))
  tf_lock_table_name   = try(local.backend_config.dynamodb_table, format("%s-%s-%s-%s-tf-lock", var.company_name, var.platform_name, var.environment, var.aws_region))
}

resource "aws_s3_bucket" "tf_state" {
  count  = local.managed_s3_backend ? 1 : 0
  bucket = local.tf_state_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = local.tf_state_bucket_name
    StagePlane  = "true"
    Environment = var.environment
    Purpose     = "terraform-state"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  count  = local.managed_s3_backend ? 1 : 0
  bucket = aws_s3_bucket.tf_state[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "tf_state" {
  count  = local.managed_s3_backend ? 1 : 0
  bucket = aws_s3_bucket.tf_state[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  count  = local.managed_s3_backend ? 1 : 0
  bucket = aws_s3_bucket.tf_state[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  count        = local.managed_s3_backend ? 1 : 0
  name         = local.tf_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = local.tf_lock_table_name
    StagePlane  = "true"
    Environment = var.environment
    Purpose     = "terraform-state-lock"
  }
}
