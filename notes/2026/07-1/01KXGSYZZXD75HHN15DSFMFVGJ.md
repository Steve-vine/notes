---
id: 01KXGSYZZXD75HHN15DSFMFVGJ
created: 2026-07-14T17:14:30.781220175Z
updated: 2026-07-14T17:14:36.03117939Z
type: task
title: PCI DSS v4.0.1 framework + sub-requirements
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 63
sprint: s3j9yhs
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Add **PCI DSS v4.0.1** to the framework library (ADR 0010) — the sub-requirements (X.Y level) across all 12 principal requirements as requirements. Mirrors the M8 CIS / M9 SOC 2 / M10 CSF imports; the generic Frameworks/coverage/crosswalk/search UI picks it up with no UI changes. New phase (beyond ADR 0014); content under ADR 0010.

- [ ] Vendor `data/frameworks/pci-dss-4-0-1.csv` (`ref,title`) — the PCI DSS v4.0.1 sub-requirements, ordered by Requirement → sub-requirement, refs as `1.1`…`12.10` (~64 sub-requirements). Titles = short descriptors/paraphrases, **NOT** the verbatim PCI SSC text (copyrighted) — same approach as the ISO/CIS/SOC 2 imports.
- [ ] Add `("pci-dss-4-0-1", "PCI DSS", "4.0.1", "pci-dss-4-0-1.csv")` to `_FRAMEWORKS` in `seed/frameworks.py`.
- [ ] Tests (`tests/test_frameworks.py`): import seeds the PCI framework + its sub-requirements; `display_order` preserved (1.1 leads; requirement 2 before 10; within a req X.2 before X.10 by display_order); idempotent; framework-count assertion (4 → 5).
- [ ] No chart change — the deploy's post-upgrade import Job already runs `import-frameworks`.

12 principal requirements: 1 network security controls, 2 secure configuration, 3 protect stored account data, 4 protect data in transit, 5 anti-malware, 6 secure systems/software, 7 access by business need-to-know, 8 identify users/authenticate, 9 physical access, 10 log and monitor, 11 test security, 12 information security policies. Caveat: sub-requirements authored from PCI DSS v4.0.1; sanity-check refs/titles against the official source. Reminder: avoid unquoted commas in any field. Refs: ADR 0010, 0017.

---
*Migrated from Linear [DEV-490](https://linear.app/stevevine/issue/DEV-490/pci-dss-v401-framework-sub-requirements) · created 2026-06-19 · completed 2026-06-19*