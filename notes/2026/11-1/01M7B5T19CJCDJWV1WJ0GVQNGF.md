---
id: 01M7B5T19CJCDJWV1WJ0GVQNGF
created: 2026-11-13T19:23:02.828585Z
updated: 2026-11-14T00:54:34.706934Z
type: task
title: Every collected check has an ID, and Polaris knows which check is on screen when you open it from a check under review or a check's page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1805
sprint: spsp226
blocked_by:
- 01M7AKAHNNRFAAG07ZH7278E0K
comments:
- id: 01M7BRS2X8DZN785FB9RVZYMDV
  author: Steve Vine
  at: 2026-11-14T00:54:34.664392Z
  text: |-
    Done — PR #1802 (auto-merge on). Migration 0847 numbers the existing checks; the ADR 0142 amendment is appended.
    - Every collected check and every proposal has an ID, CHK-n, numbered per company and never reused. It shows beside the name on a control's Evidence tab, on Checks ▸ Review (an ID column in the list and on the card) and on Checks ▸ All checks. A re-created check gets a new ID and shows "Replaces CHK-9". Built-in Compass checks keep their names with no number.
    - Search finds "CHK-14" (or "chk14"), or a check by name. A proposal waiting for review opens its Review card.
    - Existing checks (live, off and retired) and waiting proposals were numbered in the order they were made. An approved proposal took its check's number; discarded ones got none.
    - The Review card and an expanded check on the Evidence tab tell Polaris which check is on screen, the same way the DDQ pages do for a question. The status bar reads "Moneypenny · Posture ▸ Checks · CHK-14".
    - Polaris can look up a check by its ID: what it reads, the fields it keeps, its sample and its state. The how-collected, review, re-run and range tools name checks by ID and accept one.
    - Choice made: a conversation started while a check is on screen gets Posture's tools, even from a control's page (normally the Playbook section). Otherwise Polaris wouldn't have the check tools there.
    Unit suite, integration (including a migration upgrade test), lint, tsc and drift checks pass.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Steve, 2026-11-13. With a proposed check open on Checks ▸ Review, Polaris didn't know which check "this one" was. There's also no ID to name a check by in conversation.

## What people see

- Every collected check has an ID, **CHK-n**, shown beside its name. A proposal gets its ID when Polaris proposes it and keeps it once approved. A recreated check gets a new ID that names the one it replaces.
- The ID shows on the Review list and card, a control's Evidence tab, Checks ▸ All checks, and in search. CHK-n finds it.
- Opening Polaris while a check is on screen (a Review card, or a check expanded on a control's Evidence tab) tells Polaris which check it is. The status bar reads "Moneypenny · Posture ▸ Checks · CHK-14". "Tighten this one to the review period" then needs no ID.
- Polaris's tools find a check, or a check under review, by its ID: what it reads, its fields, its sample, and its state.

## Decisions (made, say if wrong)

- IDs are numbered per company, and are never reused.
- The built-in Compass checks (MFA, dormant accounts) keep their names. They aren't numbered.

## Done when

- Proposals and checks carry CHK-n from creation, shown in the places above, and searchable.
- The Review card and an expanded check publish the check to Polaris, as the DDQ pages do for a question. Polaris names it in the status bar and its tools resolve "this check".
- The existing Moneypenny proposals and live checks are numbered.
- There are tests.

**On the chain** (migration: the ID; API). After COM-1795.