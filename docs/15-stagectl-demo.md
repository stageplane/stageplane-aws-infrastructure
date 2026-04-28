<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# StagePlane stagectl Demo

## Intent

Provides a presentation-friendly demonstration of the expected `stagectl`
operator workflow for this public infrastructure repository.

## Demo script

Run the banner demo locally:

```bash
./demo/stagectl-demo.sh
```

## What it shows

- how operators consume the released `stagectl` binary
- the normal site lifecycle command flow
- the separation between the public repo and the private controller source
- the sensitive-output handling expectation

## Example lifecycle

```bash
STAGECTL=./bin/stagectl make check-tools
STAGECTL=./bin/stagectl make list-sites
STAGECTL=./bin/stagectl make describe-site SITE_NAME=site-default
STAGECTL=./bin/stagectl make validate SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform
STAGECTL=./bin/stagectl make plan SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform
STAGECTL=./bin/stagectl make deploy SITE_NAME=site-default STAGECTL_CLOUD=aws STAGECTL_IAC_RUNTIME=terraform
STAGECTL=./bin/stagectl make bootstrap-gitops SITE_NAME=site-default
```


Before running licensed features outside the demo script, provide a valid StagePlane license via `STAGECTL_LICENSE_FILE`. Free/core lifecycle commands do not require a license.
