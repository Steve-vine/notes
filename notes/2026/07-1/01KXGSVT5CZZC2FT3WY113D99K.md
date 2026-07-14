---
id: 01KXGSVT5CZZC2FT3WY113D99K
created: 2026-07-14T17:12:46.508314588Z
updated: 2026-07-14T17:12:53.349250131Z
type: task
title: Core↔CIS starter crosswalk
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 58
sprint: sr1y7pm
---
A conservative Core↔CIS crosswalk so assessments roll up to CIS coverage (ADR 0010). Mirrors the M3 ISO mappings; bulk curation is a governance concern done via the crosswalk UI.

- [ ] Vendor `data/mappings/cis-controls-v8.csv` (`core_ref,requirement_ref,note`) — a **conservative, high-confidence** starter set mapping Compass Core controls (`controls.csv` refs) → CIS v8 safeguard refs, with short notes. Only unambiguous matches (per ADR 0010 / the ISO precedent).
- [ ] Add `("cis-controls-v8", "cis-controls-v8.csv")` to `_MAPPINGS` in `seed/mappings.py`.
- [ ] Tests (`tests/test_mappings.py`): CIS mappings resolve + apply; unresolved refs skipped; idempotent.
- [ ] Seeds on deploy (import Job already runs `import-mappings`); CIS coverage then derives from the M2 assessments via the crosswalk.

Refs: ADR 0010, 0011. Depends on: CIS framework + safeguards (<issue id="ffdbb62f-e5f7-460d-99b3-c550704321a2" href="https://linear.app/stevevine/issue/DEV-474/cis-controls-v8-framework-153-safeguards">DEV-474</issue>).

---
*Migrated from Linear [DEV-475](https://linear.app/stevevine/issue/DEV-475/corecis-starter-crosswalk) · created 2026-06-19 · completed 2026-06-19*