---
id: 01M5QDDNHD7DREKV04RQXS1WK5
created: 2026-10-24T16:55:35.725834Z
updated: 2026-10-24T16:55:45.209104Z
type: task
title: The assistant is called Polaris everywhere in Compass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1288
sprint: ssgnel8
assignee: steve
priority: medium
task_status: todo
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
