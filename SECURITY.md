# Security Policy

## Supported repositories

This repository is part of the StagePlane project.

- Website: https://stageplane.io
- GitHub organization: https://github.com/stageplane
- Security contact: security@stageplane.io
- General contact: hello@stageplane.io
- Support contact: support@stageplane.io

## Reporting a vulnerability

Please do **not** file public GitHub issues for suspected security vulnerabilities.

Report security concerns privately to:

- security@stageplane.io

Include as much detail as possible:

- affected repository and version
- impacted command, workflow, or document
- reproduction steps
- expected vs observed behavior
- any logs or screenshots that help explain the issue

If the issue involves secrets, licenses, CI credentials, backend configuration, or production infrastructure, redact sensitive data before sending.

## Scope examples

Examples of relevant reports include:

- secret exposure or unsafe secret handling
- license or feature-gating bypasses
- unsafe bootstrap or GitOps credential handling
- backend/state leakage or unintended data disclosure
- CI/release integrity issues
- command-execution flows that bypass intended safeguards

## Response expectations

StagePlane will aim to:

1. acknowledge receipt
2. assess impact and reproducibility
3. determine remediation priority
4. coordinate a fix and disclosure path appropriate to the issue

## Support vs security

Use:

- support@stageplane.io for normal product/support questions
- hello@stageplane.io for general/project inquiries
- security@stageplane.io for vulnerabilities or security-sensitive disclosures
