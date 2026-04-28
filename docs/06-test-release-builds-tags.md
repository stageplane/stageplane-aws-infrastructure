<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Test, release, builds, and tags

Recommended sequence: fmt -> init -> validate -> plan -> policy checks -> tagged release.


## Native Terraform module tests

This repository uses Terraform's built-in `stagectl test` framework for module
contract validation. Tests live beside modules under `tests/` and focus on:
- stable input and output contracts
- plan-time validation
- mocked child-module behavior for fast local and CI execution

Operators can run the current test suite with:

```bash
STAGECTL=./bin/stagectl make test
```
