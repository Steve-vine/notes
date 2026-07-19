---
id: 01KXGSV8QGMH7D0Y75FB45J34F
created: 2026-07-14T17:12:28.656360995Z
updated: 2026-07-14T17:12:33.779393781Z
type: task
title: CIS Controls v8 framework + 153 safeguards
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 57
sprint: sr1y7pm
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Add **CIS Controls v8** to the framework library (ADR 0010) — the 153 Safeguards as requirements. Mirrors the M3 ISO import; the generic Frameworks/coverage/crosswalk/search UI picks it up with no UI changes. New phase (beyond ADR 0014); content under ADR 0010.

- [ ] Vendor `data/frameworks/cis-controls-v8.csv` (`ref,title`) — the 153 CIS Controls v8 **Safeguards** (refs `1.1`…`18.x`), titles = the public safeguard names only (no copyrighted descriptive text, matching the ISO import). Ordered 1.1, 1.2, …, 18.x.
- [ ] Add `("cis-controls-v8", "CIS Controls", "v8", "cis-controls-v8.csv")` to `_FRAMEWORKS` in `seed/frameworks.py`.
- [ ] Tests (`tests/test_frameworks.py`): import seeds the CIS framework + 153 requirements; idempotent; `display_order` preserved; update framework-count assertions (1 → 2).
- [ ] No chart change — the deploy's post-upgrade import Job already runs `import-frameworks`.

Caveat: the safeguard list is authored from CIS v8; sanity-check the refs/titles against the official CIS source. Refs: ADR 0010, 0017.

---
*Migrated from Linear [DEV-474](https://linear.app/stevevine/issue/DEV-474/cis-controls-v8-framework-153-safeguards) · created 2026-06-19 · completed 2026-06-19*