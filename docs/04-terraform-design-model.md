<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Terraform design model

Stage roots own orchestration and remote state. Reusable modules own implementation. Modules remain single-main-file unless complexity requires child modules.


## YAML-driven settings

This layer treats `deployments/<site>/config/general_settings.yaml` as the human-authored source of truth. The repository wrappers render it into a generated tfvars JSON artifact at runtime so Terraform remains the execution engine while operators keep a more readable configuration format.
