# StagePlane Quickstart

This quickstart deploys the AWS reference baseline with the bundled `stagectl` binary.

## Prerequisites

- AWS account access.
- AWS credentials configured for the target account.
- The bundled `./bin/stagectl` binary from the public package, or a matching controller release binary.
- A configured site under `deployments/`.

## Configure the site

Edit:

```text
deployments/site-default/config/general_settings.yaml
```

Review at minimum:

- AWS region
- AWS profile or credential source
- cluster name
- VPC CIDR
- availability zones
- backend mode
- compute node groups

## Bootstrap backend state

Run the foundation stage first. In managed backend mode this creates the backend state infrastructure and persists the runtime backend contract.

```bash
./bin/stagectl deploy \
  --site site-default \
  --cloud aws \
  --stage stage-0_0
```

## Deploy the full baseline

```bash
./bin/stagectl deploy \
  --site site-default \
  --cloud aws
```

## Optional runtime selection

```bash
./bin/stagectl deploy \
  --site site-default \
  --cloud aws \
  --iac-runtime opentofu
```

## Optional license

Core workflows do not require a license. Licensed features require a StagePlane license file.

```bash
export STAGECTL_LICENSE_FILE=./license.yaml
```

Licensed features include advanced multi-site operations, selective mutating stage/level execution, and central/shared GitOps bootstrap.

## Common commands

```bash
./bin/stagectl plan --site site-default --cloud aws
./bin/stagectl validate --site site-default --cloud aws
./bin/stagectl status --site site-default --cloud aws
./bin/stagectl output --site site-default --cloud aws
```
