<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Stage 0 - General configuration root

## Purpose

Normalizes shared platform settings into a stable remote-state contract used by all later stages.

## Responsibility boundary

This module owns only the concern named by the module and exposes a stable contract to its caller.

## File contract

This module follows the repository standard:
- `README.md`
- `main.tf`
- `variables.tf`
- `output.tf`
- `version.tf`

## Main implementation order

`main.tf` is ordered as:
1. `locals`
2. `data`
3. resources
4. child `module` blocks

## Example cases

- Example usage is shown in the sibling stage root.


## Exit criteria

A release of this module is acceptable when:
- the input and output contracts are documented and stable
- the module validates with current provider constraints
- example consumers can plan successfully
- comments explain architectural intent instead of restating Terraform syntax


## YAML-driven settings

This layer treats `deployments/<site>/config/general_settings.yaml` as the human-authored source of truth. The repository wrappers render it into a generated tfvars JSON artifact at runtime so Terraform remains the execution engine while operators keep a more readable configuration format.
