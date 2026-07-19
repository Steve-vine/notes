---
id: 01KXGSYBGVBGAA8M4ZHNVXY2QV
created: 2026-07-14T17:14:09.819529818Z
updated: 2026-07-14T18:33:14.061670971Z
type: task
title: Core↔NIST CSF starter crosswalk
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 62
sprint: s7xztsf
blocked_by:
- 01KXGSXS93AG6CJFZ497HCCGDZ
assignee: steve
label:
- brief
priority: medium
task_status: done
---
A conservative Core↔NIST CSF 2.0 crosswalk so assessments roll up to CSF coverage (ADR 0010). Mirrors the M8 CIS / M9 SOC 2 mappings; bulk curation is a governance concern done via the crosswalk UI.

- [ ] Vendor `data/mappings/nist-csf-2-0.csv` (`core_ref,requirement_ref,note`) — a **conservative, high-confidence** starter set mapping Compass Core controls (`controls.csv` refs) → CSF subcategory refs, with short notes. Only unambiguous matches (per ADR 0010 / the ISO+CIS+SOC 2 precedent).
- [ ] Add `("nist-csf-2-0", "nist-csf-2-0.csv")` to `_MAPPINGS` in `seed/mappings.py`.
- [ ] Tests (`tests/test_mappings.py`): CSF mappings resolve + apply; unresolved refs skipped; idempotent; cross-framework totals updated.
- [ ] Seeds on deploy (import Job already runs `import-mappings`); CSF coverage then derives from the M2 assessments via the crosswalk.

Expect Protect (PR.AA access, PR.DS data security, [PR.PS](<http://PR.PS>) platform), Detect ([DE.CM](<http://DE.CM>) monitoring), Respond (RS) and Recover (RC) to map densely to the existing Core controls; the Govern function (GV) maps to the INS/RIM/VEM governance controls, with the organizational-context/strategy (GV.OC, GV.RM) subcategories the sparsest. Refs: ADR 0010, 0011. Depends on: NIST CSF 2.0 framework + subcategories.

---
*Migrated from Linear [DEV-488](https://linear.app/stevevine/issue/DEV-488/corenist-csf-starter-crosswalk) · created 2026-06-19 · completed 2026-06-19*