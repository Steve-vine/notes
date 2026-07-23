---
id: 01KY7039FVE2E1JW1ZK4EGVSK1
created: 2026-07-23T08:05:00.539046Z
updated: 2026-07-23T09:08:57.869719Z
type: task
title: 'Documentation sweep: Notula → Notuvia in living docs'
label: chore
assignee: steve
number: 135
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Update Notula → Notuvia across the **living** documentation. Accepted ADRs are append-only (`decisions/0001`) and must **not** be edited to change meaning — they keep the historical name; the rebrand is recorded by the new ADR (DEV-734).

## Update (living docs)

* `CLAUDE.md` (~4 mentions).
* `README.md` (title + prose).
* `brief/` — `mission-brief.md`, `storage-architecture.md` (includes the `.notula/` layout — update to `.notuvia/` to match the code change), `ui.md`, `ways-of-working.md`, `data-model.md`.
* `docs/packaging-macos.md` (~10 mentions — name + identifier references).

## Do NOT touch

* `decisions/*.md` accepted ADRs (0001–0019 etc.) — leave historical text. Only the new rebrand ADR is added (separate issue).

## Done when

* All living docs read "Notuvia"; `.notula/` references in `storage-architecture.md`/packaging docs updated to match the renamed paths.
* A repo-wide grep for `notula` returns only historical ADR text and anything still owned by an open rebrand issue.

---

Linear DEV-740 · Rebrand · created 2026-06-30 · done 2026-06-30