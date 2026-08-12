---
id: 01KZVBNN8RYTPRD42VN1WKV1JB
created: 2026-08-12T16:07:47.224041Z
updated: 2026-08-12T16:08:22.681302Z
type: task
title: 'CI gap: required checks not running on merge commits'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 130
sprint: sw9wx5e
assignee: steve
imported_from: linear
label:
- follow_up
- chore
priority: high
task_status: backlog
---
Lint failures introduced by PR #14 (vitest-axe.d.ts) reached `main` because the frontend lint job was added in the same PR but appears not to have run on its own merge commit — failures only surfaced on subsequent PRs (broke PR #16, fixed by PR #17). Investigate: (a) workflow `on:` triggers — does the workflow fire on `pull_request` only, or also on `push: branches: [main]`? (b) Branch protection rules — required status checks marked as *required* or just present? (c) PR #14's actual run history: `gh run list --branch main --workflow <name>`.

Source: Obsidian To Do § From Brief 008b.

---

Imported from Linear [DEV-51](https://linear.app/stevevine/issue/DEV-51/ci-gap-required-checks-not-running-on-merge-commits) · parent DEV-14