---
id: 01KXGS0FW4BN20F9TNN2C9V2AS
created: 2026-07-14T16:57:51.236329511Z
updated: 2026-07-14T16:57:51.236329511Z
type: task
title: Framework & requirement models + import
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 30
---
Framework + requirement entities and a vendored import (ADR 0010/0015 — the schema anticipates these; M3 brings the data + read API).

- [ ] `Framework` model (`name`, `version` e.g. `ISO 27001:2022`, `description`) + `FrameworkRequirement` (`framework_id`, `ref` e.g. `A.5.18`, `title`, `description`) + migration.
- [ ] Vendored ISO 27001:2022 Annex A requirements (CSV/JSON) + an idempotent importer (mirror `seed/controls.py`), wired into the Helm import hook + CLI.
- [ ] Read API: list frameworks; list a framework's requirements. Shared, company-agnostic library (ADR 0017).

Refs: ADR 0010, 0015, 0017.

---
*Migrated from Linear [DEV-431](https://linear.app/stevevine/issue/DEV-431/framework-and-requirement-models-import) · created 2026-06-16 · completed 2026-06-16*  
*Related to (Linear): DEV-434*