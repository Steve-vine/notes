---
id: 01M7K975F3YYBZRGXARXXA5N4N
created: 2026-11-16T22:56:34.275882Z
updated: 2026-11-16T23:52:36.87701Z
type: task
title: 'Contract review IDs: CR-n becomes CRV-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1889
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
---
From Steve's testing of round 2 (staging 43d03f09): every reference should be three letters, a dash and a number. Contract reviews are **CR-n** today.

**Behaviour.** This works the same way as COM-1887 (risks and gaps) and COM-1886 (checks):
- CR-4 becomes **CRV-4**, keeping its number, and the counter carries on.
- The new form shows everywhere an ID is shown:
  - the Contracts list and review page;
  - commitments and comments that name a review;
  - exports from now on;
  - Polaris's contract tools, answers and MCP instructions.
- Old CR-n IDs still find the review in the address, in search and through Polaris, and old links redirect.
- Text written before the change keeps its wording.

**Done when**
- On staging, every contract review reads CRV-n with its old number, and CR-n still resolves.
- New reviews are numbered CRV-(next).
- The three-letter reference ADR (from COM-1887) lists CRV.
- The switch-over is checked on a copy of production data before release.
- Tests cover formatting, old IDs resolving, a new review, and the e2e selectors.

**Where** (for the builder): models/contract.py (`REVIEW_REF_PREFIX`), the route or search that resolves an ID, frontend contract pages, assistant/tools (contracts) and MCP instructions. Built after COM-1887.