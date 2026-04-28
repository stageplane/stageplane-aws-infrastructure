<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# StagePlane Platform Positioning

This repository is the **first public reference baseline** for **StagePlane** under the Option A cloud-specific repository model.

StagePlane itself is a staged Terraform/OpenTofu orchestrator with a human-first YAML configuration model and a portable operator CLI, `stagectl`. This repository demonstrates that orchestrator model through an AWS EKS-oriented baseline.

Current scope:
- AWS reference baseline for the StagePlane execution model
- consumed through the `stagectl` CLI
- shared staged execution model aligned with the StagePlane private controller

Planned public baseline siblings and additional reference baselines:
- `stageplane-azure-infrastructure`
- `stageplane-gcp-infrastructure`
- `stageplane-oci-infrastructure`

The product ships one control-plane CLI, `stagectl`. Cloud selection is a target option and future runtime concern, not a different binary per cloud.


The organizing principle is the **staged execution model**, not AWS itself. Clouds and workload types are target baselines built on the same controller contract.
