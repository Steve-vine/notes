---
id: 01KY703SDXSX5ASCQJRZ0TY7KY
created: 2026-07-23T08:05:16.861912Z
updated: 2026-07-23T08:05:16.861912Z
type: task
title: Rename the git repository (notula → notuvia)
label: chore
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 136
---
Rename the git repository itself to match the rebrand. Mostly **manual** steps (GitHub + local), not a code PR — done **last**, after the code/doc rename issues merged.

## Checklist

- [X] Rename the GitHub repo `Steve-vine/notula` → `Steve-vine/notuvia` (done via `gh repo rename`; GitHub redirects the old URL).
- [X] Update the local clone's remote to `git@github.com:Steve-vine/notuvia.git` (auto-updated by `gh repo rename`; verified with `git ls-remote`).
- [X] No references to the old repo URL/path in tracked docs or CI (grep confirmed none).
- [X] CI config + branch protection travel with the repo through a GitHub rename (CI ran green on the post-rename merges).
- [ ] **Handoff to Steve:** rename the local working folder `~/code/notula` → `~/code/notuvia` (optional/cosmetic). Not done automatically — it's the active session's working dir, so renaming it from inside would break the session. Safe to do anytime from outside.

## Notes

GitHub auto-redirects the old remote, so existing clones keep working.

---

Linear DEV-741 · Rebrand · created 2026-06-30 · done 2026-06-30