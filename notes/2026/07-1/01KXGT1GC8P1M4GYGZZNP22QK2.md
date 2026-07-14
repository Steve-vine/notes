---
id: 01KXGT1GC8P1M4GYGZZNP22QK2
created: 2026-07-14T17:15:53.096069771Z
updated: 2026-07-14T17:15:58.828288334Z
type: task
title: Cyber Essentials framework + requirements
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 67
sprint: s0f74ms
---
Add **Cyber Essentials Plus** (UK NCSC scheme) to the framework library (ADR 0010) — the requirements under the five technical control themes. Mirrors the M8-M12 imports; the generic Frameworks/coverage/crosswalk/search UI picks it up with no UI changes. New phase (beyond ADR 0014); content under ADR 0010.

- [ ] Vendor `data/frameworks/cyber-essentials.csv` (`ref,title`) — the CE requirements across the five themes, ordered by theme, refs theme-prefixed (e.g. `FW1`…`FW6`, `SC1`…`SC7`, `SU1`…`SU5`, `UAC1`…`UAC7`, `MP1`…`MP4`), ~35 requirements. Titles = concise descriptors (CE is Crown-copyright / OGL; kept consistent with the other imports). Quote titles.
- [ ] Add `("cyber-essentials", "Cyber Essentials Plus", "<edition>", "cyber-essentials.csv")` to `_FRAMEWORKS` in `seed/frameworks.py` (set the current edition/version, e.g. the named NCSC edition + year).
- [ ] Tests (`tests/test_frameworks.py`): import seeds the CE framework + its requirements; `display_order` preserved (Firewalls → Secure Configuration → Security Update Management → User Access Control → Malware Protection); idempotent; framework-count assertion (6 → 7).
- [ ] No chart change — the deploy's post-upgrade import Job already runs `import-frameworks`.

Five themes: (1) **Firewalls** — boundary/host firewalls, change default admin password, block unauthenticated inbound by default, restrict/justify inbound rules, protect admin interfaces. (2) **Secure Configuration** — remove unnecessary accounts/software/services, change default passwords, device lock/authentication, disable auto-run. (3) **Security Update Management** — licensed/supported software, remove unsupported software, auto-update, apply high/critical updates within 14 days. (4) **User Access Control** — account creation/approval, unique accounts, remove redundant accounts, MFA, separate admin accounts, least privilege. (5) **Malware Protection** — anti-malware deployed/updated/scanning (or application allowlisting). Note: "Plus" = same controls, independently audited. Caveat: authored from the NCSC/IASME "Requirements for IT Infrastructure" — sanity-check refs/titles + the edition against the official document. Refs: ADR 0010, 0017.

---
*Migrated from Linear [DEV-494](https://linear.app/stevevine/issue/DEV-494/cyber-essentials-framework-requirements) · created 2026-06-19 · completed 2026-06-19*