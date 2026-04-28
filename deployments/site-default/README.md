<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# site-default

## Purpose

This deployment site is the canonical example AWS EKS landing-zone instance for
this repository. It shows the required `config/` and `pipeline-stages/` shape
that additional sites must follow.

## Contents

- `config/` — site-specific YAML settings, backend configuration, and generated tfvars JSON
- `pipeline-stages/` — deterministic Terraform stage roots applied in controller order

## Expansion model

To add another deployment target, create a sibling directory under `deployments/`
that follows the same structure and adjust the site-specific YAML values, backend
settings, and any stage-local overrides required for that site.

## Secure key management

All site operations and controller runs must follow `docs/09-secure-key-management-sop.md`.
In particular, site YAML must not contain plaintext secrets, backend access must
use approved AWS authentication methods, and generated runtime artifacts must be
treated as operationally sensitive.


## Canonical baseline

This site is the source template for new deployments. Create a new site with `stagectl clone-site --site <new-site>` and then adjust the cloned YAML, backend settings, and environment-specific values.


## Argo CD admin password secret

Store the default Argo CD admin password for each site as a SOPS-encrypted file under `deployments/<site>/config/argocd/.secret.enc.yaml`. `stagectl` can generate and encrypt that file on first bootstrap, then decrypt and reuse it on later runs when `argocd_admin_password_sops_file` is configured in the site settings.
