# Agent skills generation

StagePlane can generate site-aware skills artifacts for operators or agentic communication workflows.

Example:

```bash
stagectl generate-skills --site site-default --cloud aws --iac-runtime terraform --skill-profile operator
```

The first release emits Markdown and JSON artifacts under:

```text
generated/agent-skills/<site>/
```

Profiles:

- `readonly`
- `operator`
- `incident-response`


> For artifacts that may be committed or shared outside the immediate operator boundary, use `--redact-identifiers` to remove site-, cluster-, and zone-specific identifiers.


---

For project contact use hello@stageplane.io. For support use support@stageplane.io. For security disclosures use security@stageplane.io.


The feature is workload-agnostic: it describes the StagePlane execution contract for a site and stage graph, not only the AWS EKS reference baseline.
