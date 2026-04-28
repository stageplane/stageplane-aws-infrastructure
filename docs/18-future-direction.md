<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Future Direction

StagePlane is launching with an AWS-first **reference baseline**, with one public baseline and one control-plane CLI: `stagectl`.

The product is not an AWS-only tool. StagePlane is a staged Terraform/OpenTofu orchestrator; the AWS EKS baseline is simply the first published example of that orchestrator model.

## Near-term priorities

- keep the AWS baseline polished and easy to install
- keep the free/core operator flows genuinely usable
- keep Terraform and OpenTofu aligned behind one runtime selection layer
- validate the open-core model with real operator feedback

## What comes next depends on real demand

The next major investment should be driven by usage, not only by roadmap enthusiasm. The likely branches are:

- deeper AWS polish and stronger operational guidance for the first reference baseline
- enterprise controls such as policy, approvals, audit, and drift workflows
- additional reference baselines across other clouds or workload categories built under the same StagePlane control-plane model

## Consistent platform principles

Even as StagePlane grows, these principles stay fixed:

- one product identity: **StagePlane**
- one operator CLI: **stagectl**
- one control-plane workflow across clouds and runtimes
- cloud as a target option, not a different binary
- Terraform and OpenTofu as interchangeable IaC engines under the same staged execution model


Near-term usability work also includes expanding generated operational artifacts such as `generate-skills` so agents and human operators share the same guardrails and command model.


---

For project contact use hello@stageplane.io. For support use support@stageplane.io. For security disclosures use security@stageplane.io.
