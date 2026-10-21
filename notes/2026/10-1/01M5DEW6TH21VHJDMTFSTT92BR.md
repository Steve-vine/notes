---
id: 01M5DEW6TH21VHJDMTFSTT92BR
created: 2026-10-20T20:08:36.433867Z
updated: 2026-10-21T09:16:47.490145Z
type: task
title: certifi 2026.5.20 — a new advisory (GHSA-6q48-6c7w-9gw2) fails the dependency scan on every PR
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1187
sprint: sq3fav7
comments:
- id: 01M5DFQPY3RT100CNT2E75VJ5P
  author: Steve Vine
  at: 2026-10-20T20:23:37.666895Z
  text: 'Done — merged in PR #1166. The backend''s certificate library is updated to the fixed release (certifi 2026.10.19), so the dependency check passes again. It was failing every pull request since the advisory came out on 19 Oct. No visible change. I raised this task during sprint 81 because the sprint''s own pull requests were blocked by it.'
assignee: steve
label:
- chore
priority: urgent
task_status: done
---
Found 2026-10-20 while shipping sprint 81 (PR #1165, COM-1160): `deps-scan` (pip-audit) reports certifi 2026.5.20 → GHSA-6q48-6c7w-9gw2, fixed in 2026.10.19 (published 2026-10-19). It isn't caused by any PR — every PR goes red until main has the fix.

## What changes

Nothing anyone sees. The certificate bundle the backend uses is updated to the fixed release.

## Notes (technical)

- certifi is transitive. Floor it in `[project] dependencies` with a "floor only" comment (the COM-815 urllib3 pattern; no `[tool.uv]` table — the sast cooldown rule), then `uv lock --upgrade-package certifi`.
- After it merges, open PRs rebase so their merge refs pick it up.

**Done when:** deps-scan is green on main and on the open sprint-81 PRs.