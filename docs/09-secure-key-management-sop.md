<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# SOP: secure key management

## Executive intent

This SOP defines the operational standard for handling credentials, encryption
keys, signing material, and secret-bearing configuration associated with this AWS
EKS landing-zone repository.

The intent is to ensure that:
- keys are never treated as ordinary configuration data
- human operators and automation use short-lived credentials whenever possible
- Terraform state and runtime artifacts do not become uncontrolled secret stores
- site-scoped deployments can be operated repeatedly without weakening the key
  management boundary
- audit, rotation, and revocation can be performed without redesigning the
  repository structure

This SOP applies to all deployment sites under `deployments/<site>/` and to the
Go orchestration layer under `stagectl/`.

## Scope

This SOP governs the following material classes:
- AWS access credentials used by humans, CI, or automation
- KMS customer-managed keys used for S3 state encryption, EKS-related services,
  EBS encryption, and other platform integrations
- application or workload secrets consumed during post-cluster onboarding
- signing keys, TLS private keys, and any other cryptographic private material
- generated Terraform artifacts that may indirectly reference or expose sensitive
  values

This SOP does **not** authorize storing raw secret values in Git, YAML settings,
module defaults, or module README examples.

## Design principles

### 1. Prefer federated and short-lived credentials

Use IAM Identity Center, role assumption, OIDC federation, or equivalent
short-lived AWS credential flows whenever possible.

Do not use long-lived IAM user access keys unless a documented exception has been
approved and a rotation owner has been assigned.

### 2. Keep secrets out of Git-tracked configuration

The repository's human-authored configuration source of truth is:

- `deployments/<site>/config/general_settings.yaml`

This file may contain environment metadata, names, toggles, and non-secret
placement values. It must not contain:
- passwords
- access keys
- private keys
- session tokens
- kubeconfig credentials
- unsealed secret payloads
- inline certificate private material

### 3. Separate configuration from secret retrieval

Terraform inputs should describe **where** secrets come from, not carry the
secret values themselves.

Examples of acceptable patterns:
- ARN of a KMS key
- name of a Secrets Manager secret
- SSM Parameter path
- identity role ARN used by a workload to retrieve its own secret at runtime

Examples of unacceptable patterns:
- embedding database passwords in YAML
- committing `.tfvars` files with secret literals
- placing cloud API keys in `variables.tf` defaults
- writing private keys into module README examples

### 4. Encrypt all persistent secret-bearing storage

Where repository operation depends on stateful stores, those stores must be
protected with encryption and access policy controls.

Required baseline:
- S3 Terraform state buckets must use SSE-KMS with a customer-managed key where
  organizational policy requires explicit key control
- S3 state bucket versioning must be enabled
- DynamoDB lock tables must be access-controlled and covered by standard AWS
  encryption behavior
- any generated local state copies on operator workstations must be treated as
  sensitive operational material and not committed to source control

### 5. Minimize secret exposure in runtime tooling

`stagectl`, wrapper scripts, CI pipelines, and Terraform execution must avoid
printing secret values to stdout/stderr.

Where a tool supports redaction or sensitive handling, that mode must be used.

## Repository rules

### Allowed in site config

The following are allowed in `deployments/<site>/config/general_settings.yaml`:
- AWS region
- environment name
- cluster naming inputs
- CIDR ranges
- DNS zone names
- feature toggles
- non-secret backend metadata
- references to secret locations, such as a secret name or ARN

### Forbidden in site config

The following are forbidden in `deployments/<site>/config/general_settings.yaml`:
- `aws_access_key_id`
- `aws_secret_access_key`
- `aws_session_token`
- PEM private keys
- SSH private keys
- kubeconfig user tokens
- static database passwords
- client secrets
- bearer tokens
- any value that would grant direct unauthorized access if the file leaked

### Generated artifacts

Generated runtime settings files such as:

- `deployments/<site>/config/generated/general_settings.runtime.tfvars.json`

must be treated as transient execution artifacts.

Design expectation:
- they remain Git-ignored
- they inherit the same no-secret rule as the YAML source
- if future extensions introduce secret references, those references must still
  point to external secret systems rather than carry plaintext values


## SOPS repository standard

The repository root `.sops.yaml` is the global policy anchor for secret-bearing
files committed under `deployments/<site>/config/`.

Current standard rule:
- `deployments/.*/config/.*\.(enc\.yaml|secret\.yaml|secrets\.yaml)$`

This rule is intentionally broad enough to cover site-scoped encrypted
configuration such as:
- `deployments/site-default/config/argocd/.secret.enc.yaml`
- `deployments/<site>/config/argocd/.secret.enc.yaml`
- `deployments/<site>/config/credentials/bootstrap.secrets.yaml`

### Site-scoped SOPS policy

Each deployment site may also carry its own local SOPS policy file:

- `deployments/<site>/config/.sops.yaml`

Intent:
- allow a site to bind encryption to a site-owned AWS KMS alias or key ARN
- keep operator workflows local to the site directory
- preserve the same repository naming pattern while supporting different
  encryption authorities per site

The site-level `.sops.yaml` must remain consistent with the repository standard:
- secret-bearing files stay under `deployments/<site>/config/`
- Argo CD durable admin credential remains under `config/argocd/.secret.enc.yaml`
- plaintext secret files must not be committed

### Argo CD durable local-control secret

The durable Argo CD admin password used by `stagectl` bootstrap must be stored
as a SOPS-encrypted file at:

- `deployments/<site>/config/argocd/.secret.enc.yaml`

This path is deliberate:
- it matches the root SOPS creation rule
- it keeps the secret under the site config ownership boundary
- it allows repeated bootstrap runs to reuse the same durable credential without
  persisting plaintext

`stagectl` may seed or reuse this file, but the file itself must remain
SOPS-encrypted at rest.

## Approved credential patterns

### Human operators

Preferred order:
1. IAM Identity Center / AWS SSO
2. `aws sts assume-role` or named profile role assumption
3. temporary federated credentials issued by approved enterprise identity flows

Avoid:
- long-lived IAM user keys stored in shell startup files
- shared team credentials
- passing access keys through ad hoc chat messages or tickets

### CI and automation

Preferred order:
1. OIDC federation from the CI platform into AWS
2. short-lived role assumption scoped to the target site and action
3. tightly scoped break-glass credentials only if federation is not yet available

CI must not rely on committed secret files.

### Terraform providers and modules

Terraform AWS provider authentication should inherit from the runtime AWS SDK
resolution chain or explicit non-secret profile settings. Authentication material
must not be hardcoded inside Terraform modules.

## KMS operating standard

### Key ownership model

Each environment should have a clearly named customer-managed KMS key strategy
for at least the following control points where required by policy:
- Terraform state bucket encryption
- EBS volume encryption defaults where organization policy requires explicit CMK use
- workload or service integrations that mandate customer-managed encryption

### Naming and tagging guidance

KMS keys should be tagged and named consistently with site and environment
boundaries so audit and revocation can be performed without ambiguity.

Example intent fields:
- platform name
- site name
- environment
- data classification
- owner team
- rotation policy class

### Rotation

Rotation policy must be defined per key class.

Recommended baseline:
- enable AWS-managed automatic rotation where supported and aligned with policy
- document manual rotation procedures for keys that back state buckets or other
  critical control-plane services
- test recovery of encrypted state artifacts after rotation

### Key policy hygiene

KMS key policies must:
- grant the minimum required principals
- separate administrator rights from encryption/decryption usage rights
- avoid wildcard principals unless explicitly justified and reviewed
- include break-glass access only through controlled administrator roles

## Terraform state handling

Terraform state is highly sensitive because it may contain:
- resource metadata
- generated identifiers
- rendered configuration values
- provider-returned attributes that may indirectly expose secret data

Required controls:
- prefer remote state in S3 for shared or production operation
- enable bucket versioning
- restrict access to site-scoped roles
- log bucket access through CloudTrail and S3 data-event controls where required
- prevent state files from being copied into arbitrary shared locations
- review plans and module outputs so sensitive values are marked appropriately

If local backend mode is used for development or bootstrap:
- state files must remain on managed operator systems only
- local copies must not be uploaded to chat, tickets, or documentation systems
- operators must securely delete obsolete local state when no longer needed

## TLS and certificate material

Private keys for ingress, service identity, or internal TLS must not be stored in
this repository.

Approved patterns include:
- ACM for public certificate lifecycle where applicable
- cert-manager or equivalent with private key generation inside the target environment
- external secret delivery into Kubernetes using a supported secret manager

Not approved:
- committing PEM private keys to Git
- embedding TLS private keys in Terraform variables
- pasting certificate secrets into YAML configuration

## Workload secret delivery

Workloads deployed after cluster creation should retrieve secrets using a runtime
identity pattern rather than embedding secret values at deploy time.

Preferred sequence:
1. workload assumes or receives an AWS identity
2. workload reads secret material from Secrets Manager or Parameter Store
3. secret use stays inside the runtime boundary

For Kubernetes-based secret sync:
- use a supported external secret pattern or controller
- scope permissions per namespace or workload boundary
- do not turn Terraform into the long-term holder of application secrets

## `stagectl` handling rules

`stagectl` must follow these rules:
- never log raw credentials, tokens, or private key content
- fail safely if required AWS authentication is missing
- read site-scoped backend metadata without persisting secret credentials
- treat rendered settings artifacts as operationally sensitive even when they are
  not expected to contain raw secrets
- avoid writing ad hoc debug dumps of provider environments

If future enhancements add secret retrieval or signing operations, those features
must be implemented through dedicated providers or AWS services rather than local
plaintext file staging.

## Operator procedure

### Before deployment

1. Confirm the target site under `deployments/<site>/` is correct.
2. Confirm `general_settings.yaml` contains no plaintext secrets.
3. Authenticate to AWS using an approved short-lived method.
4. Confirm the active identity matches the intended deployment account and role.
5. If using remote state, confirm the backend bucket, lock table, and KMS policy
   are already provisioned and access is restricted appropriately.

### During deployment

1. Use `stagectl` or approved wrapper scripts rather than ad hoc Terraform
   invocations where possible.
2. Avoid running with shell tracing enabled when credentials may be present in the
   environment.
3. Review Terraform plan output for accidental secret exposure.
4. Stop and remediate immediately if a secret literal appears in logs, plan output,
   or rendered artifacts.

### After deployment

1. Verify state location and access controls.
2. Remove any temporary local files that were created for debugging.
3. Rotate or revoke any temporary exception credentials used during deployment.
4. Record any security deviations or manual key-handling steps in the release log.

## Roadblocks

Common roadblocks:
- legacy automation that still expects static access keys
- teams trying to place secrets directly in YAML for convenience
- externally provisioned backend buckets without proper KMS or policy controls
- application teams expecting Terraform to inject long-lived secrets into workloads

## Risks

Primary risks addressed by this SOP:
- credential leakage through Git or generated artifacts
- overbroad KMS permissions
- Terraform state disclosure
- unauthorized cross-site access to deployment backends
- operational drift caused by undocumented credential exceptions

## Suitability

This SOP is suitable for:
- regulated or audit-sensitive platform environments
- multi-site landing-zone deployments
- teams using Terraform and Go-based orchestration with shared operational standards

This SOP is not sufficient by itself for highly specialized cryptographic key
ceremony requirements. Those require an additional organization-specific key
custody and approval process.

## Exit criteria

This SOP is considered implemented for a site when:
- no plaintext secrets are stored in site YAML or committed tfvars artifacts
- operators use approved short-lived AWS authentication
- remote state is encrypted and access-controlled when used
- key ownership and rotation responsibility are documented
- workload secret delivery uses runtime retrieval or an approved secret sync pattern
- deployment and release reviewers can verify the controls without tribal knowledge

## Test and release expectations

Before promoting this repository or a site configuration change:
- run secret scanning on the repo and generated artifacts
- verify `.gitignore` still excludes generated runtime artifacts and local state
- review backend configuration for encryption and least privilege
- validate that no module output unintentionally exposes sensitive data
- confirm release notes document any key-policy or secret-delivery changes

## Example patterns

### Good example

A site config contains:
- `region: us-west-2`
- `terraform_state_bucket: my-platform-state`
- `terraform_lock_table: my-platform-locks`
- `state_kms_key_arn: arn:aws:kms:...`
- `workload_secret_name: /platform/site-default/app/db`

This is acceptable because it carries references and metadata, not secret payloads.

### Bad example

A site config contains:
- `aws_access_key_id: AKIA...`
- `aws_secret_access_key: ...`
- `db_password: supersecret`
- `tls_private_key_pem: -----BEGIN PRIVATE KEY-----`

This is not acceptable because it turns the repository into a secret store.


## Argo CD admin password secret

Store the default Argo CD admin password for each site as a SOPS-encrypted file under `deployments/<site>/config/argocd/.secret.enc.yaml`. `stagectl` can generate and encrypt that file on first bootstrap, then decrypt and reuse it on later runs when `argocd_admin_password_sops_file` is configured in the site settings.


## Terraform Output Handling

Terraform outputs must be treated as classified or sensitive operational data in this repository. stagectl may inspect output metadata for orchestration and operator awareness, but it must not print raw output values to stdout or persist them into unencrypted artifacts.
