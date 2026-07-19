---
id: 01KXH04QAERP9C4ZAW7P7FCX2W
created: 2026-07-14T19:02:29.966075842Z
updated: 2026-07-19T21:30:29.815328531Z
type: task
title: 'Docs: switch working-practice docs from Linear to Notuvia (ADR 0038)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 164
comments:
- id: 01KXH13RK29N0FE7DKWJQ86DS9
  author: Steve Vine
  at: 2026-07-14T19:19:27.074473921Z
  text: 'Development complete on feature/com-164-notuvia-docs. PR #155: https://github.com/Steve-vine/compass/pull/155. Docs-only change: new ADR 0038 (work tracking moves to Notuvia, amends 0016/0019) plus CLAUDE.md, CONTRIBUTING.md, README.md, docs/ci.md, app/backend/README.md and the ways-of-working/phasing briefs updated to Notuvia terminology (tasks/sprints, COM-<n> ids, feature/com-<n>-slug branches, Backlog → ToDo → Active → Review → Done + Cancelled). Historical DEV-NNN references left intact (migration map memo resolves them). Note along the way: one earlier working-tree revision of these edits was lost to a git reset --hard while resetting staging and was re-applied before commit. Branch merged to staging for the batch; awaiting PR CI + merge clearance. First task through the loop under Notuvia.'
- id: 01KXH2YJ4XH3BZ747SKKVYR61K
  author: Steve Vine
  at: 2026-07-14T19:51:33.789099306Z
  text: 'PR #155 squash-merged to main (341a6ad), branch deleted. Full PR CI green on the re-run (backend 4m19s, deps-scan clean after COM-165''s pillow bump landed first). Docs now state Notuvia as the tracking tool: ADR 0038 + CLAUDE.md, CONTRIBUTING.md, README.md, docs/ci.md, backend README, ways-of-working and phasing briefs. Done — first release cycle completed end-to-end under Notuvia (COM-164 + COM-165).'
task_status: done
---
Update the repo documentation to reflect that Notuvia (not Linear) is the work-tracking tool, following the 2026-07-14 migration.

- [x] New ADR `decisions/0038-work-tracking-moves-to-notuvia.md` — records the switch, amends the work-tracking clauses of ADR 0016/0019 (append-only, so those stand as history)
- [x] CLAUDE.md — "How we work": Notuvia tasks/sprints, COM-123 references, `notuvia` MCP, `feature/com-NNN` branches; ADR list
- [x] CONTRIBUTING.md — workflow, branch example, Definition of Done
- [x] brief/ways-of-working.md — board statuses (Backlog → ToDo → Active → Review → Done + Cancelled), 7-step loop, labels table, resolved section
- [x] docs/ci.md — branch convention
- [x] README.md + app/backend/README.md — one-line mentions
- Historical DEV-NNN references left intact (resolve via the migration map memo)

First task taken through the full loop under the new tracking system.