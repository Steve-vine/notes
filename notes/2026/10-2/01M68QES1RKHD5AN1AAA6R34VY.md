---
id: 01M68QES1RKHD5AN1AAA6R34VY
created: 2026-10-31T10:18:03.19239Z
updated: 2026-10-31T13:00:06.019479Z
type: task
title: 'Dependency advisories: pyasn1 0.6.5 and pypdf 6.21.4 — the dependency scan fails every PR until they land'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1483
sprint: scpaa6p
comments:
- id: 01M68RD727Y77RK4TKGAM29PRR
  author: Steve Vine
  at: 2026-10-31T10:34:40.583037Z
  text: 'Done: PR #1487 merged. pypdf is now 6.21.4 and pyasn1 0.6.5, and those two are the only packages that moved in the lock. deps-scan was green. The sprint''s PRs are being rebased onto it so their dependency scan passes. Nothing to test on screen.'
- id: 01M690QG03HEW3963612JJGZQE
  author: Steve Vine
  at: 2026-10-31T13:00:06.019259Z
  text: 'Pre-UAT: Passed. The dependency scan has been green on every PR since, and staging runs the patched pypdf and pyasn1. Nothing on screen.'
assignee: steve
label:
- chore
priority: urgent
task_status: review
---
Sprint 100, Actions. Found on 2026-10-31 at about 10:00 GMT, when COM-1470's PR (#1486) went red on deps-scan.

## What's wrong

pip-audit reports 11 newly published advisories:
- **pyasn1 0.6.4** (four CVEs, fixed in 0.6.5). It's transitive, pulled in by the LDAP stack.
- **pypdf 6.21.2** (seven CVEs, fixed in 6.21.3/6.21.4). It's a direct dependency, used to merge PDFs.

deps-scan is a required check, so no PR can merge until main carries the fixed versions.

## Fix

- Raise the floor `pypdf>=6.21.4`.
- Add `pyasn1>=0.6.5` to `[project] dependencies` as a floor for the transitive package, with no `[tool.uv]` table (that trips the sast cooldown rule).
- Run `uv lock --upgrade-package pypdf --upgrade-package pyasn1`.

**Chain:** independent. It's on main first, and the sprint's PRs rebase onto it.

**Done when:** it's merged, and deps-scan is green on the Actions PRs.