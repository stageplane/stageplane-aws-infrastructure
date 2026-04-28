<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Deployment Pipeline Directory Naming Convention

## Purpose

This document defines the required directory naming convention for deployment
pipeline stages under each site.

The convention exists so the repository can support dynamic stage discovery while
still preserving deterministic orchestration order, readable review flows, and a
stable operator mental model.

## Scope

This convention applies to every directory under:

```text
deployments/<site>/pipeline-stages/
```

It is enforced by `stagectl validate`.

## Required format

Each stage directory **must** use this exact pattern:

```text
stage-<level>_<order>-<stage-name>
```

### Field definitions

- `stage-`  
  Required prefix indicating the directory is an orchestrated deployment stage.
- `<level>`  
  Numeric major phase of the deployment pipeline. Lower levels run earlier.
- `<order>`  
  Numeric position inside the level. Lower values run earlier within that level.
- `<stage-name>`  
  Human-readable functional name for the stage.

## Stage-name rules

The `<stage-name>` section should follow these rules:

- use lowercase characters only
- use `-` and `_` as separators only when needed
- reflect the landing zone, platform, or workload function clearly
- avoid generic names such as `misc`, `temp`, or `new`

## Examples

Valid examples:

```text
stage-0_0-landingzone_general-config
stage-1_0-landingzone_aws-vpc
stage-2_0-landingzone_aws-route53
stage-3_0-landingzone_aws-eks-cluster
stage-3_1-landingzone_aws-eks-cluster-addons
stage-4_0-landingzone_aws-argocd
```

Invalid examples:

```text
0_0-landingzone_general-config      # missing required stage- prefix
stage-1-landingzone_aws-vpc         # missing order component
stage-one_0-landingzone_aws-vpc     # level must be numeric
stage-3_1_2-eks                     # malformed level/order segment
stage-3_0-                          # missing stage name
```

## Ordering model

`stagectl` discovers stages dynamically from the directory tree and sorts them
using this precedence:

1. `level`
2. `order`
3. directory name as a final deterministic tie-breaker

This means the directory name is not cosmetic. It is the orchestration contract.

## Uniqueness rule

Each site should treat `<level>_<order>` as a unique orchestration slot.

Example:

- `stage-3_0-landingzone_aws-eks-cluster`
- `stage-3_0-landingzone_another-cluster`

The above pair is invalid because both stages claim the same execution slot.
`stagectl validate` rejects this.

## Design guidance

Use the numbering to communicate intent:

- `0_x` for global or foundational configuration
- `1_x` for primary networking foundations
- `2_x` for shared platform dependencies
- `3_x` for control-plane and cluster services
- `4_x` and above for workloads, applications, and tenant-facing layers

When a new stage is needed, add a new directory instead of changing controller
code. The directory name is the extension point.

## Validation behavior

`stagectl validate` checks that:

- the `pipeline-stages` directory contains valid stage directory names
- each stage directory matches the required naming pattern
- no two stage directories reuse the same `<level>_<order>` slot
- the resulting discovered order is deterministic

## Relationship to stagectl

The Go controller uses this convention to infer additional behavior:

- `stage-0_0-*` receives the generated runtime tfvars file
- the primary EKS cluster stage can trigger post-deploy kubeconfig refresh

These behaviors remain convention-based so new sites can be added without
hardcoding stage lists in the controller.
