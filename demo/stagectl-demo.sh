#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#
# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Demonstrates the expected operator-facing stagectl command flow for this
# public infrastructure repository without requiring a live AWS environment.
# This script is presentation-oriented and does not provision resources.
# -----------------------------------------------------------------------------

set -euo pipefail

cat <<'BANNER'
============================================================
 StagePlane AWS public baseline demo
 stagectl consumer model for the AWS infrastructure package
============================================================
BANNER

cat <<'TEXT'

Example operator flow

  1. Install or place the approved binary and set a valid license
     export STAGECTL=./bin/stagectl
     export STAGECTL_LICENSE_FILE=/path/to/stageplane-license.json

  2. Inspect available sites
     make list-sites

  3. Describe the default site
     make describe-site SITE_NAME=site-default

  4. Validate before planning or deployment
     make validate SITE_NAME=site-default

  5. Preview changes
     make plan SITE_NAME=site-default

  6. Deploy
     make deploy SITE_NAME=site-default

  7. Bootstrap Argo CD GitOps if enabled for the site
     make bootstrap-gitops SITE_NAME=site-default

  8. Inspect redacted outputs and site status
     make output SITE_NAME=site-default
     make status SITE_NAME=site-default

Notes

  - This script is a demo and does not call stagectl directly.
  - Terraform outputs are treated as sensitive and should not be exposed in plaintext.
  - Runtime-generated files under deployments/<site>/config/generated/ must not be committed.
TEXT
