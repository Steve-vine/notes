---
id: 01KXGS0FW4BN20F9TNN2C9V2AS
created: 2026-07-14T16:57:51.236329511Z
updated: 2026-07-19T21:30:27.984801867Z
type: task
title: Framework & requirement models + import
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 30
sprint: s9wnr7r
comments:
- id: 01KXGS0W2KABSFM3GQ1K6WXHZ0
  author: Steve Vine
  at: 2026-07-14T16:58:03.731391105Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 21:00 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/27 — the first M3 brief.

    All three checklist items delivered:
    - **Models** — `Framework` + `FrameworkRequirement` (migration 0009), shared/company-agnostic reference data; `ref` unique within a framework; `display_order` so refs sort naturally.
    - **Vendored import** — all **93** ISO/IEC 27001:2022 Annex A controls in `data/frameworks/iso-27001-2022.csv` (ref + public title only — clause text is copyrighted), imported idempotently by `seed/frameworks.py` + `cli import-frameworks`, wired into the Helm import hook.
    - **Read API** — `GET /frameworks` (with `requirement_count`), `/{slug}`, `/{slug}/requirements`; mirrors the domains API. Any authenticated user.

    Verification: backend ruff/mypy(src) clean, 27 unit + 59 integration pass (migration up/down + importer exercised); helm lint clean. No frontend (that's DEV-433).

    This unblocks DEV-432 (crosswalk), DEV-434 (coverage) and DEV-435 (SoA). Left at In Review — say the word and I'll merge.
assignee: steve
task_status: done
priority: medium
---
Framework + requirement entities and a vendored import (ADR 0010/0015 — the schema anticipates these; M3 brings the data + read API).

- [ ] `Framework` model (`name`, `version` e.g. `ISO 27001:2022`, `description`) + `FrameworkRequirement` (`framework_id`, `ref` e.g. `A.5.18`, `title`, `description`) + migration.
- [ ] Vendored ISO 27001:2022 Annex A requirements (CSV/JSON) + an idempotent importer (mirror `seed/controls.py`), wired into the Helm import hook + CLI.
- [ ] Read API: list frameworks; list a framework's requirements. Shared, company-agnostic library (ADR 0017).

Refs: ADR 0010, 0015, 0017.

---
*Migrated from Linear [DEV-431](https://linear.app/stevevine/issue/DEV-431/framework-and-requirement-models-import) · created 2026-06-16 · completed 2026-06-16*  
*Related to (Linear): DEV-434*