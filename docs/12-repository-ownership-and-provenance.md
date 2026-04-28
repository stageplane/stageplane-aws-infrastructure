<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Repository Ownership and Provenance

## Intent

Defines how this repository expresses authorship, ownership, and provenance so the package clearly reflects Vladimir Fonseca as the repository owner and baseline author.

## Ownership model

This repository should express ownership in multiple places instead of relying on one banner or one README sentence. The package now carries ownership markers in:

- `LICENSE`
- `NOTICE`
- `OWNERSHIP.md`
- `CODEOWNERS`
- `RELEASE_MANIFEST.md`
- root `README.md`
- file-level intent and provenance comments

## Important limit

No repository can technically stop a bad-faith party from making a false ownership claim. What this repository can do is make authorship and change-governance explicit enough that the claim is easier to challenge and substantiate.

## Recommended operational practices

- use signed commits and signed tags
- publish checksums for release artifacts
- keep release manifests with each baseline artifact
- preserve ownership files in every future delta
- avoid removing authorship headers from core files
