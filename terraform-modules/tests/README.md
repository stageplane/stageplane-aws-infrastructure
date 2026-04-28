# Module native test allowlist

This file controls the module directories exercised by native `terraform test`
and `tofu test` in CI and by `stagectl test` when the public baseline is used.

The allowlist intentionally includes modules whose contracts can be validated
offline and deterministically with provider mocks and child-module overrides.

It intentionally excludes deep composition-root wrappers such as:

- `terraform-modules/aws-modules/aws-eks-cluster`
- `terraform-modules/landingzone-aws-eks-cluster`

Those EKS composition roots are still covered indirectly through their leaf
child module contract tests (`control-plane-access`, `managed-node-groups`,
`pod-identity`) and through higher-level StagePlane stage/controller flows, but
they are not stable native `terraform test` / `tofu test` targets because they
still pull a deep third-party module graph into the plan path.

If a module is added here, it should meet the repo contract-test standard:

- fully offline
- deterministic
- provider-mocked where needed
- child-module boundaries overridden where appropriate
- no dependency on live cloud credentials or upstream service availability
