# Stagectl release distribution

## Intent

This document explains how the public AWS baseline consumes `stagectl` without committing a single architecture-specific binary into the infrastructure repository.

## Ownership boundary

The public AWS baseline owns the repository-local shim and the release manifest that pins the expected controller version. The public `stageplane/stagectl-releases` repository owns architecture-specific release binaries, checksums, and the installer script.

## Non-responsibilities

This repository does not build the private controller from source, publish release binaries, issue licenses, or store customer credentials.

## Model

The public AWS baseline uses both supported distribution patterns:

1. **Installer model** — operators run the public installer directly.
2. **Shim model** — `./bin/stagectl` is a small shell wrapper that downloads and delegates to the correct OS/architecture binary.

The shim avoids the common failure where a Linux AMD64 binary is committed and then fails on macOS/ARM with `exec format error`.

## Install from docs or shell

```bash
curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

Pinned version:

```bash
STAGECTL_VERSION=20260502060000 \
  curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

## Repo-local usage

```bash
export STAGECTL=./bin/stagectl
export STAGECTL_VERSION=20260502060000
make validate SITE_NAME=site-default STAGECTL_IAC_RUNTIME=terraform
```

## CI usage

The GitHub Actions workflows call `.github/scripts/install-stagectl.sh`, which supports:

- the repo-local shim
- direct URL override with `STAGECTL_DOWNLOAD_URL`
- version pinning with `STAGECTL_VERSION`
- alternate release repositories with `STAGECTL_RELEASE_REPO`

## Public operations credentials

The `public-operations` workflow uses GitHub OIDC and an assumable AWS role. Configure the repository secret:

```text
AWS_ROLE_TO_ASSUME=arn:aws:iam::<account-id>:role/<stageplane-operations-role>
```

Do not use long-lived `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY` secrets for public operations.

Before enabling deploy or destroy, configure the GitHub Environment named `public-operations` with required reviewers.
