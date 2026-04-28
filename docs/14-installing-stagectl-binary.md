<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Installing stagectl for the StagePlane AWS Public Repository

## Intent

This repository consumes the released `stagectl` binary but does not ship the
controller source code. The `bin/` directory exists as a local drop location for an
approved binary release. Some packaged release zips may already include
`./bin/stagectl` for operator convenience, but the Git repository itself does
not commit that binary.

## Supported binary locations

- `stagectl` available in `PATH`
- `./bin/stagectl` in this repository

## Recommended local install

1. Obtain the approved `stagectl` release binary from the private controller
   release channel if your release package did not already include it.
2. Create the local binary drop if needed:
   ```bash
   mkdir -p ./bin
   ```
3. Copy the binary into place:
   ```bash
   cp /path/to/stagectl ./bin/stagectl
   chmod 0755 ./bin/stagectl
   ```
4. Verify it:
   ```bash
   ./bin/stagectl list-sites
   ```

## Makefile usage with a local binary drop

```bash
STAGECTL=./bin/stagectl make check-tools
STAGECTL=./bin/stagectl make deploy SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform
```

## Notes

- Do not commit the binary into Git.
- Keep the binary version aligned with the release guidance for this repository.
- Prefer checksummed and signed release artifacts when available.


## License requirement

Only licensed `stagectl` features require a valid StagePlane license file. This public
baseline does not ship one. Obtain a license from the private StagePlane
controller release channel and export:

```bash
export STAGECTL_LICENSE_FILE=/path/to/stageplane-license.json
```


The public AWS baseline supports both Terraform and OpenTofu. Set `STAGECTL_IAC_RUNTIME=terraform` or `STAGECTL_IAC_RUNTIME=opentofu` before running controller-driven workflows.


After installation, operators can also generate agent-facing skills artifacts:

```bash
./bin/stagectl generate-skills --site site-default --cloud aws --iac-runtime terraform
```


---

For project contact use hello@stageplane.io. For support use support@stageplane.io. For security disclosures use security@stageplane.io.


## Repository layout for controller artifacts

- `./bin/stagectl` is the primary execution path for operators and GitHub Actions.
- `./packages/` is reserved for packaged controller artifacts, checksums, and future multi-platform release assets.

Use `./bin/stagectl` for normal execution. Treat `./packages/` as the distribution/catalog area rather than the default runtime path.
