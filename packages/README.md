# StagePlane packaged controller artifacts

This directory is reserved for packaged `stagectl` controller artifacts and related release metadata.

## Execution path vs distribution path

- `./bin/stagectl` is the primary convenience path used by operators and GitHub Actions in this public baseline.
- `./packages/` is the distribution-oriented area for packaged controller binaries, checksums, and future multi-platform artifacts.

## Current model

The public baseline may ship a convenience `./bin/stagectl` binary so operators and CI can run immediately after checkout or unzip.

Future release preparation may also stage one or more packaged controller binaries under `./packages/` for cataloging or distribution workflows without changing the primary execution path.
