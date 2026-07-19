---
id: 01KXGSX0XJJR863FG67P9QBDNF
created: 2026-07-14T17:13:26.194670022Z
updated: 2026-07-19T21:30:26.440327389Z
type: task
title: Core↔SOC 2 starter crosswalk
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 60
sprint: sywxatr
blocked_by:
- 01KXGSWG8WG3MPZEGQZ1X7HA21
assignee: steve
task_status: done
priority: medium
---
A conservative Core↔SOC 2 crosswalk so assessments roll up to SOC 2 coverage (ADR 0010). Mirrors the M8 CIS mappings; bulk curation is a governance concern done via the crosswalk UI.

- [ ] Vendor `data/mappings/soc-2-tsc-2017.csv` (`core_ref,requirement_ref,note`) — a **conservative, high-confidence** starter set mapping Compass Core controls (`controls.csv` refs) → Trust Services Criteria refs, with short notes. Only unambiguous matches (per ADR 0010 / the ISO+CIS precedent).
- [ ] Add `("soc-2-tsc-2017", "soc-2-tsc-2017.csv")` to `_MAPPINGS` in `seed/mappings.py`.
- [ ] Tests (`tests/test_mappings.py`): SOC 2 mappings resolve + apply; unresolved refs skipped; idempotent; cross-framework totals updated.
- [ ] Seeds on deploy (import Job already runs `import-mappings`); SOC 2 coverage then derives from the M2 assessments via the crosswalk.

Expect the Common Criteria (CC6 access, CC7 ops/monitoring, CC8 change, CC9 risk) to map densely to the existing Core controls; Privacy (P-series) maps mainly to the PDH controls and stays the sparsest. Refs: ADR 0010, 0011. Depends on: SOC 2 framework + criteria.

---
*Migrated from Linear [DEV-486](https://linear.app/stevevine/issue/DEV-486/coresoc-2-starter-crosswalk) · created 2026-06-19 · completed 2026-06-19*