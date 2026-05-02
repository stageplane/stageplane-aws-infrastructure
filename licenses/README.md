# Development license material

This public AWS baseline does **not** ship a reusable StagePlane license file. Free/core workflows do not require one, but licensed features do.

To run `stagectl` commands that require a license, obtain a valid license from the
private StagePlane controller release channel or from your internal distribution
process, then set:

```bash
export STAGECTL_LICENSE_FILE=/path/to/stageplane-license.json
```

For GitHub Actions, materialize the license from a protected secret such as
`STAGECTL_LICENSE_JSON_B64`.
