---
id: 01KXGT2370WR9TZBM0NKJQ0AV2
created: 2026-07-14T17:16:12.384818598Z
updated: 2026-07-14T18:33:18.733258108Z
type: task
title: Core↔Cyber Essentials starter crosswalk
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 68
sprint: s0f74ms
blocked_by:
- 01KXGT1GC8P1M4GYGZZNP22QK2
---
A conservative Core↔Cyber Essentials crosswalk so assessments roll up to CE coverage (ADR 0010). Mirrors the M8-M12 mappings; bulk curation is a governance concern done via the crosswalk UI.

- [ ] Vendor `data/mappings/cyber-essentials.csv` (`core_ref,requirement_ref,note`) — a **conservative, high-confidence** starter set mapping Compass Core controls (`controls.csv` refs) → CE requirement refs, with short notes. Only unambiguous matches. **No unquoted commas in notes** (DictReader spill).
- [ ] Add `("cyber-essentials", "cyber-essentials.csv")` to `_MAPPINGS` in `seed/mappings.py`.
- [ ] Tests (`tests/test_mappings.py`): CE mappings resolve + apply; unresolved refs skipped; idempotent; cross-framework totals updated.
- [ ] Seeds on deploy (import Job already runs `import-mappings`); CE coverage then derives from the M2 assessments via the crosswalk.

**Expect near-complete coverage** — CE's five themes map almost 1:1 to Compass's Core controls: Firewalls → NES.8/DBC.10/DBC.11/ENE, Secure Configuration → DBC.2/DBC.13/DBC.14/DBC.16/ACC.22, Security Update Management → PAM.1/PAM.2/PAM.4/ASM.11, User Access Control → ACC.4/ACC.5/ACC.6/ACC.25/CRD.3, Malware Protection → THP.10/THP.11/THP.12/THP.13. Few if any requirements should be left unmapped. Refs: ADR 0010, 0011. Depends on: Cyber Essentials framework + requirements.

---
*Migrated from Linear [DEV-495](https://linear.app/stevevine/issue/DEV-495/corecyber-essentials-starter-crosswalk) · created 2026-06-19 · completed 2026-06-19*