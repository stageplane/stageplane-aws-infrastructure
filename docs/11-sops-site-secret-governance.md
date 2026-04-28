<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# SOPS site secret governance

## Intent

This document defines how SOPS-encrypted files should be organized for each
deployment site so repository automation, operator workflows, and audit reviews
all follow the same secret placement model.

## Required directory model

Each site owns its encrypted configuration under:

- `deployments/<site>/config/`

Each site may also define its own local SOPS policy at:

- `deployments/<site>/config/.sops.yaml`

The local policy should remain compatible with the repository root `.sops.yaml`
while allowing a site to use a site-specific KMS alias.

## Required Argo CD secret path

The durable local-control secret for Argo CD bootstrap must live at:

- `deployments/<site>/config/argocd/.secret.enc.yaml`

This file must be committed only in encrypted form.

## Why this path is mandatory

This convention keeps the secret:
- within the site ownership boundary
- covered by the repository SOPS path rule
- discoverable by `stagectl` without hardcoded per-site exceptions
- stable across repeated bootstrap runs

## Example operator workflow

From the repository root:

```bash
sops --encrypt deployments/site-default/config/argocd/.secret.enc.yaml
```

From the site config directory using the site-scoped SOPS policy:

```bash
cd deployments/site-default/config
sops --encrypt argocd/.secret.enc.yaml
```

## Example site-level SOPS policy

```yaml
creation_rules:
  - path_regex: deployments/site-default/config/.*\.(enc\.yaml|secret\.yaml|secrets\.yaml)$
    kms: arn:aws:kms:us-west-2:111122223333:alias/stageplane-sops-site-default
    encrypted_regex: '^(data|stringData|secrets|credentials)$'
```

## Validation expectation

A site is considered correctly modeled only when:
- encrypted Argo CD secret file is under `config/argocd/`
- site SOPS policy exists or the site uses the repository root policy by design
- plaintext secret material is absent from `general_settings.yaml` and generated
  tfvars files
