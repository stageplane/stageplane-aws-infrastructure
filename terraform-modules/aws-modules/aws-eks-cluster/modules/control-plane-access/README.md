<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# EKS child module - control plane access

## Purpose

Defines an example access-entry posture that replaces legacy aws-auth-centric administration.

## Responsibility boundary

This child module owns a narrow EKS concern inside the parent EKS wrapper.

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

- Refer to the parent aws-eks-cluster module for composition examples.


## Exit criteria

A release of this module is acceptable when:
- the input and output contracts are documented and stable
- the module validates with current provider constraints
- example consumers can plan successfully
- comments explain architectural intent instead of restating Terraform syntax
