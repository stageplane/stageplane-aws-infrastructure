<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# AWS module - Route53 wrapper

## Purpose

Creates private hosted-zone resources with a minimal and explicit contract suitable for landing-zone orchestration.

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
