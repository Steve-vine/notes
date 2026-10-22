---
id: 01M5JTJ305VSXWP0MBB7WS28YM
created: 2026-10-22T22:08:59.909224Z
updated: 2026-10-22T22:08:59.909224Z
type: task
title: Answer a question — Compass suggests matching library answers, the answer cites where it came from and can attach evidence, and the page says whether it can be given to this client
assignee: steve
label: feature
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1257
---
Sprint 84, DDQ-1 (ADR in COM-1245). The heart of the sprint.

**Chain:** on the chain — migration + API

## What people see

**DDQ ▸ Questions:** grouped by section, each with its status and progress at the top ("31 of 48 answered, 12 approved"). Filters: status, assigned to, held back.

**Answering one:**
- **Suggestions from the library:** the closest approved entries, best first, with a match strength. **Use** copies the response, answer, sources and evidence in as a draft, linked to the entry.
- **Short response** (limited to the client's choices, where they have them) and **Answer**.
- **Sources:** pick a library entry, a policy or standard, a control or an evidence item. **Evidence to include:** evidence items, trust centre documents, policies.
- **Classification:** defaults to the highest of its sources; it can be set lower with a reason (COM-1245 call 7).
- **Can this be given?** Checked against the sharing rules and this DDQ's NDA, e.g. "✓ Can be given" or "✕ Held back — Sensitive needs an NDA, and none is in place". Each evidence file is checked separately.
- **Drafted by** (you, or "you, through your assistant").

Saving makes the question **Drafted**. An answer that is held back can be saved, but it can't be approved (the review task).

## Notes (technical)

- ddq_answer (versioned): response, detail, classification + reason, library entry link, sources, evidence, drafted_by + via_assistant. The same source/evidence link shapes as the library, so moving an answer into the library is a copy.
- The sharing check from the rubric task, run live and stored on save; re-run when the NDA, a classification or a rule changes.

**Done when:** a question takes a library suggestion; a Sensitive policy is held back with no NDA and becomes givable once the NDA is recorded.