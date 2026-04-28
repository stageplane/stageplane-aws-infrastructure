# Contributing

Thank you for your interest in improving the StagePlane AWS public baseline.

## Scope

This repository is the public AWS infrastructure baseline for StagePlane. The
private controller source is maintained separately.

## Contribution expectations

- keep changes delta-only and focused
- preserve file-level intent comments and provenance files
- do not commit generated runtime artifacts, `.terraform/`, or state files
- update docs when behavior changes
- keep Terraform formatting and native contract tests clean

## Before opening a PR

Run what is practical in your environment:

```bash
terraform fmt -check -recursive
make test SITE_NAME=site-default
```

If your environment does not have a valid StagePlane license for `stagectl`,
note that in the PR description.

## Contact

For general project questions use hello@stageplane.io. For support requests use support@stageplane.io. For security issues do not open a public issue; use security@stageplane.io and see SECURITY.md.
