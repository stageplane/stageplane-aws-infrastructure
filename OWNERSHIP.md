<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Ownership and Provenance

## Owner

Vladimir Fonseca is the author and owner of the repository-specific architecture, orchestration logic, documentation model, and deployment conventions contained in this package baseline.

## What is owned here

The following repository elements are claimed as Vladimir Fonseca's authored work product:

- multi-site deployment structure under `deployments/`
- StagePlane AWS baseline design and `stagectl` command model
- stage discovery and validation conventions
- site-scoped SOPS and Argo CD operating model
- repository documentation, operating SOPs, and package guidance
- Terraform module composition and integration design for this repository

## What is not claimed as owned here

This package does **not** claim ownership of:

- upstream Terraform providers or modules
- upstream Helm charts
- AWS managed services
- any third-party software incorporated by reference

## Governance rules

- This package is the authoritative baseline and source of truth for the repository unless explicitly replaced by Vladimir Fonseca.
- Changes should be delta-only against the approved baseline.
- Generated runtime artifacts must not be treated as source material.
- Repository ownership files must be preserved in future revisions.

## Provenance signals

This repository uses the following provenance markers:

- root `LICENSE`
- root `NOTICE`
- root `OWNERSHIP.md`
- root `CODEOWNERS`
- root `RELEASE_MANIFEST.md`
- file-level intent and authorship comments

## Reality check

A repository by itself cannot make a false ownership claim impossible. What it can do is make authorship, change governance, and provenance explicit, durable, and easier to substantiate. These files are intended to strengthen that posture.

## Contact and disclosure

- Website: https://stageplane.io
- GitHub organization: https://github.com/stageplane
- Project/admin contact: vladimir.fonseca@stageplane.io
- General contact: hello@stageplane.io
- Support contact: support@stageplane.io
- Security contact: security@stageplane.io
