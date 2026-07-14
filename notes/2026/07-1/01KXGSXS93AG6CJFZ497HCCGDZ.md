---
id: 01KXGSXS93AG6CJFZ497HCCGDZ
created: 2026-07-14T17:13:51.139647057Z
updated: 2026-07-14T17:13:58.422098949Z
type: task
title: NIST CSF 2.0 framework + subcategories
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 61
sprint: s7xztsf
---
Add **NIST CSF 2.0** to the framework library (ADR 0010) — the Subcategories across all six Functions as requirements. Mirrors the M8 CIS / M9 SOC 2 imports; the generic Frameworks/coverage/crosswalk/search UI picks it up with no UI changes. New phase (beyond ADR 0014); content under ADR 0010.

- [ ] Vendor `data/frameworks/nist-csf-2-0.csv` (`ref,title`) — the CSF 2.0 Subcategories, ordered by Function → Category → Subcategory, refs as `GV.OC-01`…`RC.CO-04` (~106 subcategories). Titles = short descriptors/paraphrases (NIST CSF is public domain; kept concise and consistent with the ISO/CIS/SOC 2 imports).
- [ ] Add `("nist-csf-2-0", "NIST Cybersecurity Framework", "2.0", "nist-csf-2-0.csv")` to `_FRAMEWORKS` in `seed/frameworks.py`.
- [ ] Tests (`tests/test_frameworks.py`): import seeds the CSF framework + its subcategories; `display_order` preserved (Functions ordered GV→ID→PR→DE→RS→RC; within a category XX-01 before XX-10); idempotent; framework-count assertion (3 → 4).
- [ ] No chart change — the deploy's post-upgrade import Job already runs `import-frameworks`.

Functions: Govern (GV), Identify (ID), Protect (PR), Detect (DE), Respond (RS), Recover (RC) — 22 categories. Caveat: subcategories authored from NIST CSF 2.0; sanity-check refs/titles against the official source. Refs: ADR 0010, 0017.

---
*Migrated from Linear [DEV-487](https://linear.app/stevevine/issue/DEV-487/nist-csf-20-framework-subcategories) · created 2026-06-19 · completed 2026-06-19*