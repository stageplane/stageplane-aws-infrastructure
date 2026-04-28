<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Deployments

## Purpose

The `deployments/` tree is the site-scoped orchestration boundary for this package.
Each site owns its own configuration source files and its own ordered Terraform
pipeline so the same repository can host multiple independently promotable StagePlane
pipeline examples. This public baseline happens to target AWS EKS, but the
StagePlane execution model is not limited to EKS-oriented infrastructure.

## Layout

- `deployments/<site>/config/` — site-specific human-authored settings and generated runtime artifacts
- `deployments/<site>/pipeline-stages/` — ordered Terraform stage roots for that site

## Design intent

This model prevents global configuration drift across environments and allows the
control plane to target a single site or iterate across multiple sites without
mixing settings, backend definitions, or stage state paths.

## Secure key management

All site operations and controller runs must follow `docs/09-secure-key-management-sop.md`.
In particular, site YAML must not contain plaintext secrets, backend access must
use approved AWS authentication methods, and generated runtime artifacts must be
treated as operationally sensitive.


## New site creation

Use `stagectl clone-site --site <new-site>` to create a new site from `deployments/site-default/`. This preserves the required `config/` plus `pipeline-stages/` structure and gives the new site its own independent state and runtime artifacts.


Deployment pipeline directory naming is defined in `docs/10-deployment-pipeline-directory-naming.md` and is enforced by `stagectl validate`.


## Argo CD admin password secret

Store the default Argo CD admin password for each site as a SOPS-encrypted file under `deployments/<site>/config/argocd/.secret.enc.yaml`. `stagectl` can generate and encrypt that file on first bootstrap, then decrypt and reuse it on later runs when `argocd_admin_password_sops_file` is configured in the site settings.


- SOPS site secret governance: `docs/11-sops-site-secret-governance.md`
