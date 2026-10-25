---
id: 01M5QDDNHD7DREKV04RQXS1WK5
created: 2026-10-24T16:55:35.725834Z
updated: 2026-10-25T15:40:21.492123Z
type: task
title: The assistant is called Polaris everywhere in Compass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1288
sprint: ssgnel8
comments:
- id: 01M5QHHZQNHW18JQZAD0GR2E6Y
  author: Steve Vine
  at: 2026-10-24T18:07:51.541353Z
  text: |-
    **Done: PR #1298, merged to main (635bdb54).** Not yet on staging; it goes with the rest of sprint 86.

    **What you'll see**
    - **Records made through the assistant** read "… via ✦Polaris", with a small four-point star icon (Phosphor StarFour, a pole-star nod; hidden from screen readers). This covers the Activity log, control and risk history, gaps, data requests (requests, disclosures, requests to disclose, corrections, timeline), incidents, risk assessments, plan entries and vendor reviews/approvals. Older records read the same, because only the label changed: stored values and API fields are untouched.
    - **DDQ answers** read "Drafted by Sam Patel, via ✦Polaris". Before, they read "through their assistant, through the assistant", which said it twice.
    - **The Assistant page,** its menu item and breadcrumb are "Connect Polaris". The tokens panel says "Polaris, Compass's AI assistant, does what you can do on screen…".
    - **The Roles screen permission** is "Connect Polaris". The no-token and no-grant refusals name it. The incident export says "Through Polaris".
    - **What Polaris is told when it connects:** "You are Polaris, Compass's assistant, acting as the person who connected you…", plus "Introduce yourself as Polaris when asked who you are."

    **Calls awaiting Steve**
    1. **No Activity-log filter:** the log has no filter for how a change arrived, so none was renamed or added.
    2. **Tool descriptions keep "the assistant":** they and the refusals Polaris relays ("The assistant can't delete a DDQ") still say it. Only its opening instructions say it is Polaris.
    3. **Menu icon:** the "Connect Polaris" menu item keeps its robot icon. The star appears only where Polaris is shown as the one who did something.
    4. **Roles screen heading:** the permission group is still headed "AI assistant".

    **For COM-1287:**
    - `ASSISTANT_NAME` lives in `core/via.py` (backend) and `src/assistant/polaris.ts` (frontend).
    - `PolarisName`, `PolarisIcon` and `ViaPolaris` live in `src/assistant/Polaris.tsx`.
assignee: steve
label: null
priority: medium
task_status: done
---
## What Steve said

"For this to work the AI assistant needs a name, let's call it 'Polaris'." (DDQ-3 walk-through, alongside COM-1287.)

## Behaviour

- Wherever Compass names the assistant, it says **Polaris**. That covers the "via assistant" marks on records and activity ("Raised by Steve Vine via Polaris"), the Assistant page and its connect instructions, and the Activity log's filter.
- Polaris isn't a person. It never appears in people pickers, user lists or role assignments.
- Polaris gets its own small icon, used beside its name wherever it appears, including COM-1287's assignee chip.
- The assistant's own introduction (the MCP server's instructions) says it is Polaris, working as the person who connected it.

## My calls (awaiting Steve)

- The name is fixed product-wide, not a setting per installation.
- Records keep their stored value. Only the label changes, so older records read "via Polaris" too.

## Implementation notes

- Independent (labels only, no migration or API change). The MCP server instructions text is not OpenAPI, so check whether any route docstring mentions "the assistant" before touching it (route-docstring-is-openapi-contract).
- About 26 frontend places render "via assistant" / "via the assistant": AssessmentPanel, DSR cards/notes/timeline, disclosures, RTD, GapComments, gap.ts, Incident cards, ActivityPage, AssistantPage, ControlDetailPage, RiskDetailPage, SapEntryDetailPage, risk assessment cards, SapComments, SapCompletion and more. Put one `viaLabel(via)` / `ASSISTANT_NAME` constant in a shared module and use it everywhere.
- Backend: email bodies and the activity summaries that say "via the assistant" (grep the core/actions and notifications templates); assistant/server instructions.
- Tests: update text matchers.
