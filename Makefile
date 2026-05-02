# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#
# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Provides the root operator entrypoint for this repository.
# The Makefile standardizes local and CI execution while treating stagectl as
# the primary command surface for deploy, plan, destroy, validate, and site lifecycle
# actions.
#
# Usage examples:
# - make help
# - make check-tools
# - make demo
# - make deploy SITE_NAME=site-default STAGECTL_CLOUD=aws
# - make test
# - make deploy SITE_NAME=site-default STAGECTL_CLOUD=aws
# - make deploy SITE_NAME=site-prod-usw2 STAGECTL_VERBOSITY=json
# - make plan SITE_NAME=site-default STAGECTL_CLOUD=aws
# - make destroy SITE_NAME=site-default STAGECTL_CLOUD=aws
# - make validate SITE_NAME=site-default STAGECTL_CLOUD=aws
# - make list-sites
# - make status SITE_NAME=site-default
# - make output SITE_NAME=site-default
# - make describe-site SITE_NAME=site-default
# - make lint SITE_NAME=site-default
# - make preflight SITE_NAME=site-default
# - make bootstrap-gitops SITE_NAME=site-default
# - make managed-state-preflight SITE_NAME=site-default STAGECTL_LICENSE_FILE=/path/to/license.json
# - make stage-access-describe SITE_NAME=site-default STAGECTL_LICENSE_FILE=/path/to/license.json
# - make stage-access-render-policy SITE_NAME=site-default STAGE_ACCESS_STAGE=compute STAGE_ACCESS_ACCOUNT_ID=123456789012 STAGECTL_LICENSE_FILE=/path/to/license.json
# - make clone-site SITE_NAME=site-prod-usw2 FROM_SITE=site-default
# -----------------------------------------------------------------------------

SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c

# -----------------------------------------------------------------------------
# Parameter intent: SITE_NAME
# -----------------------------------------------------------------------------
# Target site under deployments/<site> used by stagectl for lifecycle and
# inspection operations.
#
# Example:
# - SITE_NAME=site-default
# - SITE_NAME=site-prod-usw2
SITE_NAME ?= site-default

# -----------------------------------------------------------------------------
# Parameter intent: FROM_SITE
# -----------------------------------------------------------------------------
# Source site used when cloning a new site scaffold.
#
# Example:
# - FROM_SITE=site-default
# - FROM_SITE=site-prod-usw2
FROM_SITE ?= site-default

# -----------------------------------------------------------------------------
# Parameter intent: STAGECTL
# -----------------------------------------------------------------------------
# Path or command name for the released stagectl binary consumed by this
# public repository.
#
# Examples:
# - STAGECTL=stagectl
# - STAGECTL=./bin/stagectl
STAGECTL ?= stagectl

# -----------------------------------------------------------------------------
# Parameter intent: STAGECTL_VERBOSITY
# -----------------------------------------------------------------------------
# Operator-facing output format passed into stagectl.
#
# Supported values:
# - standard
# - text
# - json
#
# Examples:
# - STAGECTL_VERBOSITY=standard
# - STAGECTL_VERBOSITY=text
# - STAGECTL_VERBOSITY=json
STAGECTL_VERBOSITY ?= standard

# -----------------------------------------------------------------------------
# Parameter intent: STAGECTL_CLOUD
# -----------------------------------------------------------------------------
# Cloud target passed to stagectl for cloud-aware lifecycle commands.
# The current public baseline supports AWS.
#
# Examples:
# - STAGECTL_CLOUD=aws
STAGECTL_CLOUD ?= aws

# -----------------------------------------------------------------------------
# Parameter intent: STAGECTL_IAC_RUNTIME
# -----------------------------------------------------------------------------
# IaC runtime passed to stagectl.
# Supported values:
# - terraform
# - opentofu
STAGECTL_IAC_RUNTIME ?= terraform

# -----------------------------------------------------------------------------
# Parameter intent: STAGECTL_LICENSE_FILE
# -----------------------------------------------------------------------------
# License path for a valid externally supplied StagePlane license.
# Operators should point this at a license obtained from the private StagePlane
# controller release channel or an internal distribution process.
#
# Examples:
# - STAGECTL_LICENSE_FILE=/path/to/stageplane-license.json
# - STAGECTL_LICENSE_FILE=/secure/path/stageplane-license.json
STAGECTL_LICENSE_FILE ?=

# -----------------------------------------------------------------------------
# Parameter intent: STAGE_ACCESS_STAGE
# -----------------------------------------------------------------------------
# Logical or discovered StagePlane stage name used when rendering a provider
# state-access IAM/RBAC policy example.
STAGE_ACCESS_STAGE ?= compute

# -----------------------------------------------------------------------------
# Parameter intent: STAGE_ACCESS_ACCOUNT_ID
# -----------------------------------------------------------------------------
# AWS account id used only for rendering example IAM policy ARNs. This value is
# not used to authenticate and should be replaced by operators for real sites.
STAGE_ACCESS_ACCOUNT_ID ?= 123456789012

.PHONY: help check-stagectl check-repo-tools check-iac-runtime check-tools-common check-tools check-tools-test check-license demo test deploy plan destroy validate clone-site list-sites status output describe-site lint preflight bootstrap-gitops generate-skills managed-state-preflight stage-access-describe stage-access-render-policy

help:
	@echo "Available targets:"
	@echo "  check-tools       Verify required tools and AWS authentication"
	@echo "  demo              Show the stagectl operator demo banner and flow"
	@echo "  test              Run native Terraform tests through stagectl"
	@echo "  deploy            Deploy the selected site"
	@echo "  plan              Preview Terraform changes for the selected site"
	@echo "  destroy           Destroy the selected site"
	@echo "  validate          Validate the selected site"
	@echo "  clone-site        Clone a new site from an existing site"
	@echo "  list-sites        List available sites"
	@echo "  status            Show site status"
	@echo "  output            Show redacted site outputs"
	@echo "  describe-site     Describe the selected site"
	@echo "  lint              Run repository and Terraform formatting checks"
	@echo "  preflight         Run operator preflight checks"
	@echo "  managed-state-preflight Validate stage-scoped managed-state RBAC"
	@echo "  stage-access-describe Describe stage IAM/RBAC and state access"
	@echo "  stage-access-render-policy Render an AWS IAM state-access policy example"
	@echo "  bootstrap-gitops  Bootstrap Argo CD GitOps for the selected site"
	@echo "  generate-skills   Generate StagePlane agent skills artifacts"
	@echo ""
	@echo "Examples:"
	@echo "  make check-tools"
	@echo "  make demo"
	@echo "  STAGECTL=./bin/stagectl STAGECTL_IAC_RUNTIME=terraform make test"
	@echo "  STAGECTL=./bin/stagectl STAGECTL_IAC_RUNTIME=opentofu make test"
	@echo "  STAGECTL=./bin/stagectl make deploy SITE_NAME=site-default STAGECTL_IAC_RUNTIME=terraform"
	@echo "  STAGECTL=./bin/stagectl make deploy SITE_NAME=site-prod-usw2 STAGECTL_VERBOSITY=json"
	@echo "  STAGECTL=./bin/stagectl make plan SITE_NAME=site-default STAGECTL_IAC_RUNTIME=terraform"
	@echo "  STAGECTL=./bin/stagectl make destroy SITE_NAME=site-default STAGECTL_IAC_RUNTIME=terraform"
	@echo "  STAGECTL=./bin/stagectl make validate SITE_NAME=site-default STAGECTL_IAC_RUNTIME=terraform"
	@echo "  STAGECTL=./bin/stagectl make list-sites"
	@echo "  STAGECTL=./bin/stagectl make status SITE_NAME=site-default"
	@echo "  STAGECTL=./bin/stagectl make status SITE_NAME=site-default STAGECTL_VERBOSITY=text"
	@echo "  STAGECTL=./bin/stagectl make output SITE_NAME=site-default"
	@echo "  STAGECTL=./bin/stagectl make describe-site SITE_NAME=site-default"
	@echo "  STAGECTL=./bin/stagectl make lint SITE_NAME=site-default"
	@echo "  STAGECTL=./bin/stagectl make preflight SITE_NAME=site-default"
	@echo "  STAGECTL=./bin/stagectl make managed-state-preflight SITE_NAME=site-default STAGECTL_LICENSE_FILE=/path/to/license.json"
	@echo "  STAGECTL=./bin/stagectl make stage-access-describe SITE_NAME=site-default STAGECTL_LICENSE_FILE=/path/to/license.json"
	@echo "  STAGECTL=./bin/stagectl make stage-access-render-policy SITE_NAME=site-default STAGE_ACCESS_STAGE=compute STAGE_ACCESS_ACCOUNT_ID=123456789012 STAGECTL_LICENSE_FILE=/path/to/license.json"
	@echo "  STAGECTL=./bin/stagectl make bootstrap-gitops SITE_NAME=site-default"
	@echo "  STAGECTL=./bin/stagectl make clone-site SITE_NAME=site-prod-usw2 FROM_SITE=site-default"
	@echo "  STAGECTL=./bin/stagectl make generate-skills SITE_NAME=site-default"

check-stagectl:
	@echo "Checking required tools..."
	@test -x "$(STAGECTL)" || command -v "$(STAGECTL)" >/dev/null 2>&1 || { echo "stagectl not found. Install it in PATH or set STAGECTL=./bin/stagectl"; exit 1; }

check-iac-runtime: check-stagectl
	@case "$(STAGECTL_IAC_RUNTIME)" in \
		terraform) command -v terraform >/dev/null 2>&1 || { echo "terraform not found in PATH"; exit 1; } ;; \
		opentofu) command -v tofu >/dev/null 2>&1 || { echo "tofu not found in PATH"; exit 1; } ;; \
		*) echo "unsupported STAGECTL_IAC_RUNTIME=$(STAGECTL_IAC_RUNTIME). Use terraform or opentofu"; exit 1 ;; \
	esac

check-repo-tools: check-stagectl
	@command -v sops >/dev/null 2>&1 || { echo "sops not found in PATH"; exit 1; }
	@command -v git >/dev/null 2>&1 || { echo "git not found in PATH"; exit 1; }

check-tools-common: check-repo-tools check-iac-runtime

check-license:
	@test -n "$(STAGECTL_LICENSE_FILE)" || { echo "STAGECTL_LICENSE_FILE is not set. Obtain a valid StagePlane license and set STAGECTL_LICENSE_FILE=/path/to/stageplane-license.json"; exit 1; }
	@test -f "$(STAGECTL_LICENSE_FILE)" || { echo "license file not found at $(STAGECTL_LICENSE_FILE). Set STAGECTL_LICENSE_FILE=/path/to/stageplane-license.json"; exit 1; }

check-tools: check-tools-common
	@command -v aws >/dev/null 2>&1 || { echo "aws not found in PATH"; exit 1; }
	@command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found in PATH"; exit 1; }
	@command -v argocd >/dev/null 2>&1 || { echo "argocd not found in PATH"; exit 1; }
	@aws sts get-caller-identity >/dev/null 2>&1 || { echo "AWS CLI is not authenticated. Configure credentials and validate with: aws sts get-caller-identity"; exit 1; }
	@echo "All required tools found."

check-tools-test: check-tools-common
	@echo "All required tools found."

demo:
	@./demo/stagectl-demo.sh


test: check-tools-test
	@$(STAGECTL) test --iac-runtime $(STAGECTL_IAC_RUNTIME) --verbosity $(STAGECTL_VERBOSITY)

deploy: check-tools
	@$(STAGECTL) deploy --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --verbosity $(STAGECTL_VERBOSITY)

plan: check-tools
	@$(STAGECTL) plan --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --verbosity $(STAGECTL_VERBOSITY)

destroy: check-tools
	@$(STAGECTL) destroy --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --verbosity $(STAGECTL_VERBOSITY)

validate: check-tools
	@$(STAGECTL) validate --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --verbosity $(STAGECTL_VERBOSITY)

clone-site: check-repo-tools check-license
	@STAGECTL_LICENSE_FILE="$(STAGECTL_LICENSE_FILE)" $(STAGECTL) clone-site --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --from-site $(FROM_SITE) --verbosity $(STAGECTL_VERBOSITY)

list-sites: check-stagectl
	@$(STAGECTL) list-sites --verbosity $(STAGECTL_VERBOSITY)

status: check-stagectl
	@$(STAGECTL) status --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --verbosity $(STAGECTL_VERBOSITY)

output: check-tools-common
	@$(STAGECTL) output --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --verbosity $(STAGECTL_VERBOSITY)

describe-site: check-repo-tools
	@$(STAGECTL) describe-site --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --verbosity $(STAGECTL_VERBOSITY)

lint: check-tools-common
	@$(STAGECTL) lint --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --verbosity $(STAGECTL_VERBOSITY)

preflight: check-tools-common
	@$(STAGECTL) preflight --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --verbosity $(STAGECTL_VERBOSITY)

managed-state-preflight: check-repo-tools check-license
	@STAGECTL_LICENSE_FILE="$(STAGECTL_LICENSE_FILE)" $(STAGECTL) preflight --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --check-managed-state --verbosity $(STAGECTL_VERBOSITY)

stage-access-describe: check-repo-tools check-license
	@STAGECTL_LICENSE_FILE="$(STAGECTL_LICENSE_FILE)" $(STAGECTL) stage-access describe --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --verbosity $(STAGECTL_VERBOSITY)

stage-access-render-policy: check-repo-tools check-license
	@STAGECTL_LICENSE_FILE="$(STAGECTL_LICENSE_FILE)" $(STAGECTL) stage-access render-policy --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --stage $(STAGE_ACCESS_STAGE) --account-id $(STAGE_ACCESS_ACCOUNT_ID) --verbosity $(STAGECTL_VERBOSITY)

bootstrap-gitops: check-tools check-license
	@STAGECTL_LICENSE_FILE="$(STAGECTL_LICENSE_FILE)" $(STAGECTL) bootstrap-gitops --iac-runtime $(STAGECTL_IAC_RUNTIME) --site $(SITE_NAME) --verbosity $(STAGECTL_VERBOSITY)


generate-skills: check-stagectl
	@$(STAGECTL) generate-skills --site $(SITE_NAME) --cloud $(STAGECTL_CLOUD) --iac-runtime $(STAGECTL_IAC_RUNTIME) --verbosity $(STAGECTL_VERBOSITY)
