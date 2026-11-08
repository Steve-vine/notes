---
id: 01M6TPN1APKZ3JX9ATRQ5W99KT
created: 2026-11-07T09:50:19.478259Z
updated: 2026-11-08T08:59:57.935624Z
type: task
title: Checks ▸ Doing says "Evidence only" instead of "Collecting" — it means evidence is collected on schedule but no rule judges it, not that a collection is running now
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1631
sprint: s5khbev
comments:
- id: 01M6TS3ZG62DQ1T1HQ2CGCXGX4
  author: Steve Vine
  at: 2026-11-07T10:33:26.278438Z
  text: |-
    **Done: merged to main in PR #1637. It reaches staging with the rest of sprint 107.**

    **What it does:** in Posture ▸ Checks, the Doing state that read "Collecting" now reads **Evidence only**. This covers the pill in the table, the side panel, the filter and the summary card.
    - **Tooltip** on the pill: "Collected on schedule. No rule judges it yet. Ask Polaris for a rule to make it pass or fail."
    - **Coverage words** for a control now read "Partly automated · evidence only". That's what chat and the Statement of Applicability show.
    - **The rule panel on a check** says "Evidence only: no pass/fail rule judges it yet."
    - **Polaris in chat** is told to call it "evidence only", not "collecting".
    - **"Collecting…" stays** only while a capture is actually running, on the control's card.

    The state itself hasn't changed, only the words.

    **To look at on staging:** Posture ▸ Checks in Test Company. SOD.9 should read "Partly automated · Evidence only".
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Raised by Steve while testing on staging (2026-11-07). He asked whether "Collecting" in the Doing column means Compass is collecting right now, or that it can collect. It means neither. It means the control's checks are live and filing evidence on schedule, with no pass/fail rule, so nothing is judged. The control's own card also says "Collecting…" while a capture is actually under way (COM-1618), so the same word means two things.

## Done when

- **The Doing state reads "Evidence only"** everywhere it appears:
  - the Coverage table's Doing column and its filter;
  - the coverage words on a control ("Partly automated · Evidence only");
  - the Needs attention and summary counts, if they name it;
  - the chat tools' wording (`posture_collection_coverage` and similar);
  - any export.
  
  The pill has a tooltip: "Collected on schedule. No rule judges it yet. Ask Polaris for a rule to make it pass or fail."
- **"Collecting…" is kept only for a capture in progress** (the control card's waiting message).
- **No change to the state itself**: the API value `collecting` may stay, or be renamed `evidence_only` with the schema regenerated, whichever is less churn. The words on screen and in chat are what change.
- Tests are updated: `checks/coverage.ts` labels, CoverageTab, and the chat tool test.
- On staging: SOD.9 shows "Partly automated · Evidence only". After a rule is approved it shows Passing or Failing.

## Where

- `app/frontend/src/checks/coverage.ts` (DOING labels)
- `app/backend/src/compass_api/core/collection/coverage.py` (DOING_WORDS)
- `assistant/tools/posture_collection.py`