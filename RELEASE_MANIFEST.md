<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Release Manifest

## Current release artifact

- Artifact: `stageplane-aws-infrastructure-20260428203108.zip`
- Package owner: Vladimir Fonseca
- Repository model: Public StagePlane AWS infrastructure repository with binary-consumption model for `stagectl`
- Release status: Validated baseline candidate

## Validation record

- Validation date: 2026-04-28
- Native Terraform contract baseline: previously validated through `make test SITE_NAME=site-default` in the approved AWS baseline line
- Controller dependency model: external `stagectl` binary, no private source included
- Runtime license model: license supplied externally by operator workflow or protected CI secret when licensed features are used; no reusable license file is shipped in this package

## Current release summary
- correct the public positioning copy so StagePlane is described as a general staged Terraform/OpenTofu orchestrator rather than an EKS-only product
- clarify that the AWS EKS repository is the first published reference baseline, not the definition of the product
## Prior carried-forward milestones

This baseline also includes the following previously landed capabilities:

- StagePlane / `stagectl` naming refactor across public docs, workflows, install scripts, demo content, and package metadata
- Apache License 2.0 for the public AWS baseline
- removal of bundled proprietary development license material from the public package
- public-facing README rewrite for open publication
- CI updates to inject license material from protected secrets when `stagectl`-driven contract tests are enabled
- minimal `CONTRIBUTING.md` for public collaboration guidance
- cleaned repository terminology and typo correction for infrastructure naming
- public-repo `Makefile` alignment with externally supplied `stagectl` license material
- Makefile tool-check de-duplication with shared common target and CI licensing note
- explicit `--cloud` target selection with AWS-first baseline behavior
- strengthened public README positioning and quick-start examples aligned with `--cloud aws`
- `STAGECTL_CLOUD` added to the public Makefile and operator examples
- public SOPS example aliases normalized to `stageplane-sops`
- public operator surface aligned with the open-core model so free/core workflows do not require `STAGECTL_LICENSE_FILE` while licensed features still do
- public AWS baseline brand renamed to StagePlane while preserving the `stagectl` operator surface
- Terraform/OpenTofu unified runtime selection in the public operator surface, Makefile, docs, and CI
- runtime dispatch and workflow/Makefile validation fixes discovered during full release validation

## Integrity guidance

When publishing a later release, record the following:

- release date
- artifact file name
- checksum (SHA256)
- approving owner
- material changes from prior baseline

## Ownership note

This manifest records repository-baseline provenance for this package and should travel with release artifacts.

## 2026-04-28 validation note

- Preserved full public baseline file count.
- Enforced unified `compute.node_groups` contract as the only worker capacity source of truth.
- Removed legacy flat EKS sizing keys from active settings and tests.
- Kept optional `compute.karpenter.node_pools` and Fargate capacity under the unified compute model.
- Hardened Fargate/EC2 node group Terraform input schema and restored missing test assertion condition.

- Backend managed/external model

- Added backend.hcl.example for backend configuration discoverability
- Clarified LICENSE for evaluation usage
- Completed settings-layer logging propagation for compute stage scaling.
- Refreshed bundled bin/stagectl with embedded version 20260428203108.
