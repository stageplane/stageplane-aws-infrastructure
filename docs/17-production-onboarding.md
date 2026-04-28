<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Production Onboarding

This guide is the shortest path from evaluating StagePlane locally to operating the AWS baseline in a production-like environment.

## Recommended onboarding order

1. **Choose the operator runtime**
   - Select Terraform or OpenTofu.
   - Set `STAGECTL_IAC_RUNTIME` explicitly in CI and operator shells.
2. **Define AWS account and IAM ownership**
   - Separate the account or environment boundary used for the landing zone.
   - Decide which role or profile owns state, KMS, Route53, EKS, and add-on changes.
3. **Create the state backend**
   - Provision the S3 bucket and DynamoDB lock table for Terraform/OpenTofu state.
   - Define bucket encryption, retention, logging, and IAM policy before first deploy.
4. **Establish KMS and SOPS policy**
   - Choose the KMS key alias and ownership model.
   - Keep encrypted site secrets under SOPS and avoid plaintext secrets in YAML.
5. **Create and review the first site**
   - Start from `site-default`.
   - Review `deployments/<site>/config/general_settings.yaml` line by line.
   - Confirm region, CIDRs, hosted zone, cluster version, node sizing, and runtime selection.
6. **Run free/core validation first**
   - `make list-sites`
   - `make validate SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform`
   - `make plan SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform`
7. **Define GitOps ownership before bootstrap**
   - Decide whether the cluster will self-host Argo CD or join a shared central Argo control plane.
   - Remember: local bootstrap is free/core, central/shared onboarding is a licensed workflow.
8. **Promote to production conventions**
   - Lock runtime versions in CI.
   - Pin the controller binary version.
   - Document approval rules for `deploy`/`destroy` and any licensed selective staging workflows.

## Minimum production decisions

Before first production use, explicitly document:

- AWS account ownership and separation model
- IAM role strategy for operators and CI
- state bucket / lock table names and retention posture
- KMS key ownership and rotation posture
- DNS ownership for Route53 hosted zones
- EKS admin and break-glass access model
- Argo CD ownership model
- backup / recovery expectations for state and secrets

## What StagePlane assumes

StagePlane helps with staged execution, site packaging, settings rendering, and consistent operator flow. It does **not** replace:

- your AWS account boundary decisions
- your IAM model
- your security review process
- your KMS ownership model
- your incident or recovery procedures

## First production recommendation

For the first real production rollout:

- use a single AWS account or clearly separated environment account
- keep one site per clearly owned environment boundary
- start with whole-site free/core flows before enabling licensed selective staging for mutating operations
- keep GitOps bootstrap local/self-hosted unless you already have a shared central Argo control plane

## Compute contract validation checklist

Before promotion, confirm the site uses the unified StagePlane compute contract:

- `compute.node_groups` is present and contains at least one explicit group.
- Fargate groups define only `fargate.namespaces`; they must not define EC2 `instance` or `scaling` fields.
- Spot groups provide at least two instance types for diversification.
- Mixed groups define `capacity.mixed.ondemand.base` and are expanded by `stagectl` before Terraform/OpenTofu execution.
- Optional Karpenter capacity is declared under `compute.karpenter`; if `enabled: true`, at least one `node_pools` entry must be present.

These checks belong in the controller so operators get deterministic contract errors before provider initialization or module evaluation.
