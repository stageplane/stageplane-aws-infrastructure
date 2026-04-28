# StagePlane Release — 20260428211650

## Summary

This release keeps the validated StagePlane technical baseline intact and adds the external-facing documentation surface needed for early customer evaluation.

StagePlane is a staged Terraform and OpenTofu orchestrator with a human-first YAML configuration model and a portable CLI (`stagectl`). The AWS baseline remains the first reference implementation, not the definition of the platform.

## Highlights

### Backend lifecycle

- Managed backend mode remains the default.
- `stage-0_0` bootstraps backend state infrastructure for the AWS baseline.
- External backend mode remains available for teams that already manage Terraform/OpenTofu state.

### Structured logging

- Settings-layer compute scaling uses the controller logging path.
- No internal compute-stage debug output is emitted with raw `fmt.Printf`.

### Unified compute model

- `compute.node_groups` remains the authoritative compute contract.
- On-demand, spot, mixed, Fargate, and optional Karpenter capacity patterns remain supported.
- Minimum compute validation is enforced by the controller.

### Governance and packaging

- Public and controller packages remain separate.
- The public package continues to carry the bundled `bin/stagectl` binary for operator and CI convenience.
- Documentation entry points are included for quickstart, release notes, and customer-facing overview.

## Artifacts

- `stageplane-aws-infrastructure-20260428211650.zip`
- `stageplane-controller-20260428211650.zip`
- `stageplane-docs-site-20260428211650.zip`

## Status

Ready for early customer and internal platform-team evaluation.
