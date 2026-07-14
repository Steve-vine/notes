---
id: 01KXGT0RFY6EPVYXBQM42W7YXR
created: 2026-07-14T17:15:28.638627283Z
updated: 2026-07-14T18:33:16.890894792Z
type: task
title: Core↔HIPAA starter crosswalk
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 66
sprint: spyhsng
blocked_by:
- 01KXGT066RNQ873SH8VRVPEK2E
---
A conservative Core↔HIPAA crosswalk so assessments roll up to HIPAA coverage (ADR 0010). Mirrors the M8 CIS / M9 SOC 2 / M10 CSF / M11 PCI mappings; bulk curation is a governance concern done via the crosswalk UI.

- [ ] Vendor `data/mappings/hipaa-2013.csv` (`core_ref,requirement_ref,note`) — a **conservative, high-confidence** starter set mapping Compass Core controls (`controls.csv` refs) → HIPAA standard/implementation-spec refs, with short notes. Only unambiguous matches (per ADR 0010 / the ISO+CIS+SOC 2+CSF+PCI precedent). **No unquoted commas in notes** (DictReader spill).
- [ ] Add `("hipaa-2013", "hipaa-2013.csv")` to `_MAPPINGS` in `seed/mappings.py`.
- [ ] Tests (`tests/test_mappings.py`): HIPAA mappings resolve + apply; unresolved refs skipped; idempotent; cross-framework totals updated.
- [ ] Seeds on deploy (import Job already runs `import-mappings`); HIPAA coverage then derives from the M2 assessments via the crosswalk.

Expect 164.312 Technical (access → ACC/CRD, audit → EVM, transmission encryption → KMC), 164.308 Administrative (risk → RIM, training → SEA, incident → IMA, contingency → BCR/DBR), 164.310 Physical (→ PES/EHD) to map densely; the healthcare-specific items (clearinghouse function isolation, business-associate/group-health-plan contract specifics, breach-to-HHS/media notification) will be the sparsest. Refs: ADR 0010, 0011. Depends on: HIPAA framework + safeguards.

---
*Migrated from Linear [DEV-493](https://linear.app/stevevine/issue/DEV-493/corehipaa-starter-crosswalk) · created 2026-06-19 · completed 2026-06-19*