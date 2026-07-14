---
id: 01KXGT066RNQ873SH8VRVPEK2E
created: 2026-07-14T17:15:09.912808475Z
updated: 2026-07-14T17:15:09.912808475Z
type: task
title: HIPAA framework + safeguards
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 65
---
Add **HIPAA** (Security Rule + Breach Notification Rule, 45 CFR Part 164, 2013 Omnibus) to the framework library (ADR 0010) — the standards + implementation specifications as requirements. Mirrors the M8 CIS / M9 SOC 2 / M10 CSF / M11 PCI imports; the generic Frameworks/coverage/crosswalk/search UI picks it up with no UI changes. New phase (beyond ADR 0014); content under ADR 0010.

- [ ] Vendor `data/frameworks/hipaa-2013.csv` (`ref,title`) — the Security Rule + Breach Notification Rule standards/implementation specs, ordered by section, refs as `164.308(a)(1)(ii)(A)`…`164.414(b)` (~58 requirements). Titles = concise descriptors (HIPAA is US-Gov public domain; kept consistent with the other imports). Quote all titles (parentheses/commas safe inside quotes).
- [ ] Add `("hipaa-2013", "HIPAA (Security & Breach Notification)", "2013", "hipaa-2013.csv")` to `_FRAMEWORKS` in `seed/frameworks.py`.
- [ ] Tests (`tests/test_frameworks.py`): import seeds the HIPAA framework + its requirements; `display_order` preserved (164.308 leads, sections ordered 308→310→312→314→316→Breach 402-414); idempotent; framework-count assertion (5 → 6).
- [ ] No chart change — the deploy's post-upgrade import Job already runs `import-frameworks`.

Sections: 164.308 Administrative Safeguards (~23: risk analysis/management, sanction, activity review, assigned responsibility, workforce security, access management, awareness/training, incident procedures, contingency plan, evaluation, BA contracts), 164.310 Physical (~10: facility access, workstation use/security, device/media controls), 164.312 Technical (~9: access control, audit controls, integrity, authentication, transmission security), 164.314 Organizational (~4), 164.316 Policies/Documentation (~4); Breach Notification 164.402-414 (~8: breach risk assessment, individual/media/HHS notification, BA notification, burden of proof). Privacy Rule deliberately excluded. Caveat: authored from 45 CFR Part 164; sanity-check refs/titles against the official eCFR. Refs: ADR 0010, 0017.

---
*Migrated from Linear [DEV-492](https://linear.app/stevevine/issue/DEV-492/hipaa-framework-safeguards) · created 2026-06-19 · completed 2026-06-19*