<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# StagePlane AWS Infrastructure Release Manifest — 20260502053000

## Artifact

- Package: `stageplane-aws-infrastructure-20260502060000.zip`
- Component: StagePlane public AWS infrastructure baseline
- Baseline source: user-provided `stageplane-aws-infrastructure.zip`

## Release intent

This release updates the public AWS baseline for the StagePlane `managed-state-rbac` Pro / Team feature. It adds site-local stage access policy wiring, a shared stage-access profile, operator Makefile targets, public operation workflow entries, and documentation.

## Delta summary

- Added `deployments/site-default/config/stage_access.yaml`.
- Added `access-policies/stage-access/prod-default.yaml`.
- Added `docs/21-stage-access-rbac.md`.
- Updated `README.md` to describe managed-state RBAC and the new operator commands.
- Updated `Makefile` with:
  - `managed-state-preflight`
  - `stage-access-describe`
  - `stage-access-render-policy`
- Updated `.github/workflows/public-operations.yaml` with manual operations for the same stage-access commands.
- Preserved existing AWS/EKS stages, Terraform modules, GitHub workflows, SOPS model, and StagePlane public baseline layout.

## Validation

Run before promotion:

```bash
unzip -t stageplane-aws-infrastructure-20260502060000.zip
make check-stagectl STAGECTL=./bin/stagectl
make describe-site SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
```

With a Pro license, validate the managed-state RBAC example:

```bash
export STAGECTL_LICENSE_FILE=/path/to/stageplane-pro.license
make managed-state-preflight SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
make stage-access-describe SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
make stage-access-render-policy SITE_NAME=site-default STAGE_ACCESS_STAGE=compute STAGE_ACCESS_ACCOUNT_ID=123456789012 STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
```

## Security posture

The added `stage_access.yaml` and shared profile contain placeholder AWS role ARNs only. They do not contain cloud credentials, external IDs, access keys, secrets, or production account information. Operators must replace placeholder ARNs before production use.


## 20260502060000 hardening delta

- Added README warnings for GPU Spot fallback cost risk and sample Kubernetes/EKS version availability.
- Updated packaged `bin/stagectl` to the 20260502060000 hardening binary.
- Preserved StagePlane managed-state RBAC examples and binary provenance files.
