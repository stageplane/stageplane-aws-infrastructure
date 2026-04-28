<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Argo CD Site Secret Directory

## Intent

This directory holds the durable site-scoped local-control secret material used by `stagectl` during Argo CD bootstrap.

The primary secret in this directory is the encrypted Argo CD admin password file:

- `.secret.enc.yaml`

## Design Rules

- The file must remain **SOPS-encrypted** at rest.
- Plaintext Argo CD admin passwords must **not** be committed into `general_settings.yaml` for persistent environments.
- `stagectl bootstrap-gitops` and `stagectl deploy` can create this file automatically when it does not exist, using the repository root `.sops.yaml` policy or the site-scoped `deployments/<site>/config/.sops.yaml` policy when operators run SOPS commands from the site config directory.
- If the file already exists, `stagectl` reuses it so repeated bootstrap runs remain stable.

## Expected YAML Payload

```yaml
argocd_admin_password: "replace-with-a-strong-password"
```


## Kustomize Source Examples

The site configuration can provide Argo CD bootstrap sources directly in
`deployments/<site>/config/general_settings.yaml` so `stagectl` does not
hardcode repository paths.

Example values used in `site-default`:

```yaml
argocd_base_kustomize: "github.com/mycompany/aws-gitops-infrastructure//environments/dev/deployments/argocd?ref=main"
argocd_bootstrap_kustomize: "github.com/mycompany/aws-gitops-infrastructure//environments/dev/bootstrap/argocd?ref=main"
```

Use `argocd_base_kustomize` for the first Argo CD installation layer and
`argocd_bootstrap_kustomize` for the follow-on GitOps activation layer.

## Example Operator Workflow

Encrypt a chosen password into the site secret file:

```bash
cat > /tmp/argocd-admin-password.yaml <<'YAML'
argocd_admin_password: "replace-with-a-strong-password"
YAML

sops --encrypt /tmp/argocd-admin-password.yaml \
  > deployments/site-default/config/argocd/.secret.enc.yaml
rm -f /tmp/argocd-admin-password.yaml
```

Or allow `stagectl` to generate and encrypt the password automatically during bootstrap.


## Repository Policy Alignment

The default encrypted file path for the durable Argo CD password is:

- `deployments/<site>/config/argocd/.secret.enc.yaml`

This location intentionally matches the repository root `.sops.yaml` rule:

- `deployments/.*/config/.*\.(enc\.yaml|secret\.yaml|secrets\.yaml)$`

That means the file can be encrypted consistently whether SOPS is invoked from the
repository root or from the site config directory using the site-scoped
`deployments/<site>/config/.sops.yaml` file.
