<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Stage access and managed-state RBAC

## Architectural intent

This document explains how the public StagePlane AWS baseline models stage-scoped managed-state access for Pro / Team users. The feature lets teams separate site topology from IAM/RBAC execution policy so that security reviewers can audit which role may operate each StagePlane stage without reading the entire deployment model.

## Ownership boundary

This document covers the public AWS baseline files:

- `deployments/<site>/config/stage_access.yaml`
- `access-policies/stage-access/<profile>.yaml`
- Makefile and GitHub Actions entrypoints that call `stagectl stage-access` and `stagectl preflight --check-managed-state`

It does not define production AWS credentials, real customer account ids, secret values, or Enterprise policy-engine enforcement.

## File layout

```text
deployments/site-default/config/general_settings.yaml
  # site topology and deployment intent

deployments/site-default/config/stage_access.yaml
  # site-local access policy selector and overrides

access-policies/stage-access/prod-default.yaml
  # shared stage-access defaults reusable across sites
```

The separation is intentional:

```text
general_settings.yaml = what the site is
stage_access.yaml     = who/what can operate each stage and how state is isolated
pipeline-stages/      = execution order
```

## Current example

The baseline ships an example `stage_access.yaml` that selects the shared `prod-default` profile. The profile declares one AWS IAM role per stage and a per-stage S3 state key layout:

```text
sites/{{ site.name }}/stages/{{ stage.name }}/terraform.tfstate
```

Example generated state keys include:

```text
sites/site-default/stages/landingzone-aws-vpc/terraform.tfstate
sites/site-default/stages/landingzone-aws-eks-cluster/terraform.tfstate
sites/site-default/stages/landingzone-aws-argocd/terraform.tfstate
```

The default role ARNs use account id `123456789012` as a non-secret placeholder. Replace these with real customer roles before production use.

## Operator commands

All managed-state RBAC operations require a Pro / Team license with the `managed-state-rbac` entitlement.

```bash
export STAGECTL_LICENSE_FILE=/path/to/stageplane-pro.license
```

Validate the stage-access policy:

```bash
make managed-state-preflight SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
```

Describe the resolved access model:

```bash
make stage-access-describe SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
```

Render an AWS IAM policy example for the compute stage:

```bash
make stage-access-render-policy \
  SITE_NAME=site-default \
  STAGE_ACCESS_STAGE=compute \
  STAGE_ACCESS_ACCOUNT_ID=123456789012 \
  STAGECTL=./bin/stagectl \
  STAGECTL_VERBOSITY=json
```

## Security rules

- Do not place AWS access keys or secret values in `stage_access.yaml`.
- Use SOPS or runtime secret references for external IDs or other sensitive values.
- Replace all placeholder account ids and role names before production use.
- Keep `stage_access.yaml` under security/platform code review ownership.
- Use per-stage state keys if you want meaningful state isolation.

## Pro vs Enterprise

Pro / Team includes:

- `managed-state-rbac`
- stage-scoped state key rendering
- stage IAM role mapping
- static preflight validation
- AWS IAM policy example rendering

Enterprise roadmap capabilities include:

- mandatory policy-engine validation
- audit/SIEM export
- airgap signed backend-policy bundles
- live IAM policy introspection
- deny-by-policy wildcard enforcement

## Non-goals in this public baseline

The public AWS baseline does not assume roles, introspect live IAM policy documents, mutate AWS IAM, or enforce Enterprise policy-engine decisions. It provides the repo-local policy model and the operator commands needed for StagePlane to resolve and validate stage-scoped access.
