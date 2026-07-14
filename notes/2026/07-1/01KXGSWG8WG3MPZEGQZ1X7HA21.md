---
id: 01KXGSWG8WG3MPZEGQZ1X7HA21
created: 2026-07-14T17:13:09.148103211Z
updated: 2026-07-14T17:13:14.9286217Z
type: task
title: SOC 2 (Trust Services Criteria) framework + criteria
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 59
sprint: sywxatr
---
Add **SOC 2** to the framework library (ADR 0010) — the AICPA **Trust Services Criteria** across all five categories as requirements. Mirrors the M8 CIS import; the generic Frameworks/coverage/crosswalk/search UI picks it up with no UI changes. New phase (beyond ADR 0014); content under ADR 0010.

- [ ] Vendor `data/frameworks/soc-2-tsc-2017.csv` (`ref,title`) — the Trust Services Criteria, ordered, refs as `CC1.1`…`CC9.2`, `A1.1`…`A1.3`, `C1.1`…`C1.2`, `PI1.1`…`PI1.5`, `P1.1`…`P8.1` (~61 criteria). Titles = short descriptors/paraphrases, **NOT** the verbatim AICPA TSC text (copyrighted) — same approach as the ISO/CIS imports.
- [ ] Add `("soc-2-tsc-2017", "SOC 2 (Trust Services Criteria)", "2017", "soc-2-tsc-2017.csv")` to `_FRAMEWORKS` in `seed/frameworks.py`.
- [ ] Tests (`tests/test_frameworks.py`): import seeds the SOC 2 framework + its criteria; `display_order` preserved (CC1.1 before CC1.10-style refs; categories ordered CC→A→C→PI→P); idempotent; framework-count assertion (2 → 3).
- [ ] No chart change — the deploy's post-upgrade import Job already runs `import-frameworks`.

Categories: Security/Common Criteria (CC1–CC9, ~33), Availability (A1, 3), Confidentiality (C1, 2), Processing Integrity (PI1, 5), Privacy (P1–P8, ~18). Caveat: criteria authored from the AICPA TSC; sanity-check refs/titles against the official source. Refs: ADR 0010, 0017.

---
*Migrated from Linear [DEV-485](https://linear.app/stevevine/issue/DEV-485/soc-2-trust-services-criteria-framework-criteria) · created 2026-06-19 · completed 2026-06-19*