---
id: 01M7B5T19CJCDJWV1WJ0GVQNGF
created: 2026-11-13T19:23:02.828585Z
updated: 2026-11-14T01:43:07.882883Z
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
- id: 01M7BVHZVASTNAWZKG9WDVMTGJ
  author: Steve Vine
  at: 2026-11-14T01:43:07.882665Z
  text: |-
    Pre-UAT: Passed (staging 694d62c1, E2E Test Company, E2E Admin A). Screenshots: ~/compass-uat/spsp226/COM-1805/

    What I did and saw
    1. Checks ▸ Review: the list has an ID column. New checks shows CHK-1. Changes shows CHK-3 with "Replaces CHK-2" under its name. The card titles read "1 of 1 CHK-1" and "Polaris proposes CHK-1". CHK-3's card says "This replaces CHK-2 when you approve it." (01, 03)
    2. Checks ▸ All checks: the collected check reads "CHK-2 · Entra ID (Microsoft 365) directory role assignments". The built-in checks (Everyone has MFA registered, No dormant accounts…) keep their names with no number. (16)
    3. ACC.13 ▸ Evidence: the live check shows "CHK-2" beside its name, and the proposals under it show "Polaris proposes CHK-1" and "Polaris proposes CHK-3". (13, 15)
    4. Search (the top box, then Enter): "CHK-1" found the proposal ("proposed check · ACC.13 · waiting for review") and clicking it opened its Review card. "chk3" found CHK-3 and opened its card. "CHK-2" found the live check and opened ACC.13's Evidence tab. (10–12)
    5. Polaris: I opened Polaris on Checks ▸ Review; the status bar read "E2E Test Company · Posture ▸ Checks". Opening the CHK-1 card changed it to "… · Posture ▸ Checks · CHK-1". On ACC.13's Evidence tab with CHK-2 open, it read "E2E Test Company · Playbook ▸ Control · CHK-2", and when I collapsed the check the CHK part went away. (05, 06, 14)
    6. I asked Polaris, with the card open and no ID given, "Which check is this one? … Do not change anything." It answered correctly: CHK-1, waiting for review on ACC.13, what it reads (the directory audit log, RoleManagement), its sample (89 events), and that I had edited it and reset it. It changed nothing. (08)
    7. Over MCP, "how is ACC.13 collected" names the check "CHK-2 · Entra ID…".

    Small things, not blocking
    - The Review card is a pop-up that covers the top bar, so Polaris can't be opened while a card is open. You have to open Polaris first, then the card. Typing to Polaris with the card open works fine. Steve may want Polaris to be reachable from the card itself.
    - Polaris's search tool over MCP (the one that is "the same search as the box at the top") found nothing for CHK-1 or CHK-2 in E2E Test Company, while the app's search finds both. Only the app's search was in scope here, but Copilot or Claude users asking "find CHK-14" through search won't get it. Polaris's own check-by-ID lookup does work (step 6).
    - The Compass-staging connector in my Claude session didn't yet list the new "collected check by its ID" tools. Its tool list was probably cached from before the deploy. Steve may need to refresh the connector to see them.
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