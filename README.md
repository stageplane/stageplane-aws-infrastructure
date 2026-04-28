<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# StagePlane AWS Infrastructure

**The open AWS reference baseline for StagePlane** — a staged Terraform and OpenTofu orchestrator with a human-first YAML configuration model and a portable operator CLI, `stagectl`.

StagePlane is not defined by AWS or EKS. It is a staged orchestrator for multi-stage Terraform/OpenTofu pipelines across named deployment sites. This repository publishes the **first public reference baseline** for that model: an AWS EKS-oriented pipeline including Terraform modules, site-scoped deployment trees, staged execution definitions, GitOps integration points, documentation, and public automation. The controller source code stays private; operators consume the released `stagectl` binary.

## Why StagePlane

- **Lightweight and repo-centric** — keep stages, settings, and execution logic close to the infrastructure repository instead of depending on a hosted control plane.
- **Strong determinism and safety via stages** — execution order is explicit and visible rather than inferred from a hidden orchestration graph.
- **Human-first configuration** — edit one `general_settings.yaml` file per site instead of hand-managing complex tfvars.
- **Portable operator workflow** — use one `stagectl` CLI across Terraform and OpenTofu runtimes.
- **Open-core without heavy platform lock-in** — keep the public baseline Apache 2.0 while using licensed controller features only where they add value.

## Compared to alternatives

StagePlane is not trying to replace every IaC workflow. It is optimized as an **execution and operator workflow layer** for staged Terraform/OpenTofu pipelines, not as a universal IaC authoring system. It is particularly strong for platform teams that want something lightweight and repo-centric, strong determinism and safety via explicit stages, human-readable configuration, and a commercial open-core path without locking into a large vendor platform.

It is especially well-suited for teams that want a **repeatable way to operate multi-stage, multi-site Terraform/OpenTofu pipelines** with human-readable configuration and safer staged execution. The AWS EKS baseline is the first published example of this model, not the definition of the product.

Compared to common alternatives:

- **raw Terraform + GitOps** — StagePlane keeps Terraform/OpenTofu as the source of truth, but adds a consistent staged operator flow, YAML-first settings, site replication, and safer ordering
- **Terragrunt** — Terragrunt is strong for DRY Terraform composition and stack layering; StagePlane focuses more on operator ergonomics, explicit staged execution, and repeatable pipeline packaging
- **Terraform Cloud / Enterprise, env0, Spacelift** — those platforms emphasize hosted remote execution, governance, and policy services; StagePlane emphasizes a portable, repo-centric control plane with a public baseline plus a feature-gated private controller
- **Pulumi / CDK** — those shift the authoring model toward programming languages; StagePlane keeps a Terraform/OpenTofu module ecosystem with human-first YAML inputs and staged orchestration

The intended differentiator is: **repeatable multi-site Terraform/OpenTofu pipeline operation with human-first YAML, explicit staging, and a clean open-core control-plane model.**

## What this repository is

This repository is the **AWS public baseline** in the StagePlane Option A cloud-specific
public-repo model.

It provides:

- reusable Terraform modules and landing-zone wrappers
- `deployments/<site>/...` site-scoped configuration and stage trees
- human-edited `general_settings.yaml` configuration
- staged workflow ordering for network, DNS, cluster, add-ons, and GitOps
- contract tests for Terraform modules and landing zones
- public GitHub Actions for formatting, contract validation, and controlled operations

It does **not** include:

- the private StagePlane controller source
- a committed `stagectl` binary in the Git repository history
- a bundled production license

## Quick start

1. If you are using the Git repository directly, obtain a released `stagectl` binary from the private StagePlane controller release channel. The packaged release zip may already include `./bin/stagectl` for convenience.
2. Place the binary at `./bin/stagectl` or install it in `PATH`.
3. Run the free/core workflows directly.
4. Provide `STAGECTL_LICENSE_FILE` only when you need licensed features such as `clone-site`, `--all-sites`, selective mutating staging, or `bootstrap-gitops`.

Example free/core flow:

```bash
mkdir -p ./bin
cp /path/to/stagectl ./bin/stagectl
export STAGECTL=./bin/stagectl

make list-sites
make validate SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform
make plan SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform
make deploy SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform
```

Example licensed flow:

```bash
export STAGECTL_LICENSE_FILE=/path/to/stageplane-license.json
make clone-site SITE_NAME=site-prod-usw2 FROM_SITE=site-default
make bootstrap-gitops SITE_NAME=site-default
```

## Operator model

This public repository keeps Terraform as the source of truth while using `stagectl`
to standardize execution. The CLI handles:

- settings rendering from YAML to generated Terraform inputs
- staged execution ordering
- backend initialization
- selective stage and level targeting
- validation, plan, deploy, destroy, lint, output, and GitOps bootstrap workflows

## GitHub Actions

This repository includes:

- `terraform-ci.yaml`
  - binary-independent Terraform/OpenTofu formatting and native runtime test coverage
- `public-ci.yaml`
  - installs `stagectl`, formats the repository, and runs public contract tests across the selected IaC runtime
- `public-operations.yaml`
  - manual operator workflows for plan/deploy/destroy/validate and related commands

## Terraform and OpenTofu runtime selection

StagePlane supports both Terraform and OpenTofu behind the same `stagectl` control plane.

Runtime selection precedence:

1. `--iac-runtime terraform|opentofu`
2. `STAGECTL_IAC_RUNTIME`
3. site config `iac_runtime`
4. default `terraform`

## Free vs licensed features

Free/core workflows in this public baseline:

- whole-site `plan`, `validate`, `deploy`, and `destroy`
- `test`, `lint`, and `preflight`
- `list-sites`, `status`, `output`, and `describe-site`
- `generate-skills` for operator- and agent-facing skills artifacts
- basic AWS targeting with `--cloud aws` and runtime selection with `--iac-runtime terraform|opentofu`

Licensed workflows exposed by `stagectl`:

- `clone-site`
- `--all-sites` multi-site operations
- selective mutating staging with `--stage` and `--level` on `deploy` / `destroy`
- `bootstrap-gitops`


## Production onboarding

For teams moving beyond local evaluation, start with:

- `docs/17-production-onboarding.md` for the recommended first production rollout flow
- `docs/19-eks-security-baseline.md` for the StagePlane AWS security posture guidance
- `docs/09-secure-key-management-sop.md` for secret, KMS, and SOPS handling

The public baseline is usable as-is, but production adoption should explicitly define:

- AWS account and IAM role model
- Terraform/OpenTofu state bucket and lock-table ownership
- KMS and SOPS key strategy
- cluster access and GitOps bootstrap ownership
- least-privilege EKS, node, and add-on permissions

## Future direction

StagePlane is launching with the AWS public baseline first. Near-term roadmap themes are:

- polish the AWS baseline and install experience
- validate the open-core operator model with real users
- keep Terraform and OpenTofu support aligned behind one `stagectl` control plane
- let real usage determine whether the next investment is deeper AWS polish, enterprise controls, or the first additional cloud baseline

See `docs/18-future-direction.md` for the concise public roadmap view.

## Licensing and distribution model

This repository is published under the Apache License 2.0 for the AWS baseline content and can be forked, modified, and extended under that license.
The StagePlane controller source and release/distribution policy remain separate.

For local or CI execution, provide:

- `STAGECTL` for all controller-driven workflows
- `STAGECTL_LICENSE_FILE` only for licensed features

The Git repository does not ship a reusable proprietary license file. Release zips may include a convenience `./bin/stagectl` binary, but not a reusable proprietary license file.

## Repository layout

```text
deployments/
  <site>/
    config/
    pipeline-stages/

terraform-modules/
  aws-modules/
  landingzone-*/
docs/
demo/
```

## StagePlane scope today

Current public scope:
- AWS public baseline
- EKS-oriented staged infrastructure package
- `stagectl` consumer model

Architecture direction:
- Azure, GCP, and OCI public baselines as future sibling repositories
- one product identity: **StagePlane**
- one CLI identity: **stagectl**
- cloud as a target option, not a different binary


## Contact

- Website: `https://stageplane.io`
- GitHub: `https://github.com/stageplane`
- Project/admin contact: `vladimir.fonseca@stageplane.io`
- General/product contact: `hello@stageplane.io`
- Support: `support@stageplane.io`
- Security disclosures: `security@stageplane.io`
- Release notifications: `releases@stageplane.io`

## Ownership and provenance

This repository preserves provenance and governance through:

- `NOTICE`
- `OWNERSHIP.md`
- `CODEOWNERS`
- `RELEASE_MANIFEST.md`
- file-level authorship and intent comments

See `OWNERSHIP.md` for governance posture and `NOTICE` for attribution details.


Cloud targeting is explicit from the start. The current public baseline supports AWS:

```bash
stagectl validate --site site-default --cloud aws --iac-runtime terraform
stagectl plan --site site-default --cloud aws --iac-runtime terraform
stagectl deploy --site site-default --cloud aws --iac-runtime terraform
```


## Agent skills generation

StagePlane can generate operator- and agent-facing skill artifacts directly from the site configuration and resolved runtime model.

Example:

```bash
stagectl generate-skills --site site-default --cloud aws --iac-runtime terraform --skill-profile operator
```

The first release emits Markdown and JSON artifacts under `generated/agent-skills/<site>/`.


> For artifacts that may be committed or shared outside the immediate operator boundary, use `--redact-identifiers` to remove site-, cluster-, and zone-specific identifiers.
