---
id: 01M5JTJ305VSXWP0MBB7WS28YM
created: 2026-10-22T22:08:59.909224Z
updated: 2026-10-23T12:22:56.213054Z
type: task
title: Answer a question — Compass suggests matching library answers, the answer cites where it came from and can attach evidence, and the page says whether it can be given to this client
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1257
sprint: s5uw2fz
blocked_by:
- 01M5JTHTNE4V0K5BVR2B46TNE9
comments:
- id: 01M5MBDNK879E7QWC1GSCYHKH2
  author: Steve Vine
  at: 2026-10-23T12:22:55.336486Z
  text: |-
    Done — merged in #1274 (b0837108, migration 0645_ddq_answers).

    - Open a question from the DDQ's Questions list: the answer form pops up over the page (with its own link).
    - **Suggestions from the library** first: closest approved answers, best first, with how close ("82% match"), whether it can be given to this client, and an amber "Due for review" pill where due. **Use** copies its response, answer, sources and evidence in as a draft, linked to the entry.
    - **Short response** limited to the client's choices where they gave some (otherwise Yes / No / N/A / Partial suggested); **Answer**; **Sources** (a policy or standard, a control, evidence, a trust centre document); **Evidence to include**.
    - **Classification** follows the highest of the sources; it can be set lower only with a reason, which is kept.
    - **Can this be given?** checks the answer and each evidence file by its own classification against the rules and this DDQ's NDA: "Can be given" or "Held back — Sensitive — no NDA in place". Record the NDA and it shows "Can be given" straight away.
    - **Drafted by** "you" or "you, through your assistant", and how (by hand, or from the library — unchanged or changed). Every save is a version; History lists them.
    - Saving makes the question **Drafted**; the DDQ moves to **In progress** at its first answer. Questions card: status per question, a red "Held back" mark, "31 of 48 answered, 12 approved" with a bar, Status and Sharing filters.

    My calls:
    - **Whether something can be given is worked out every time it's shown, never stored** — so an NDA, reclassification or rule change shows at once. (The task said "stored on save"; COM-1263 freezes it at sending.)
    - **Use** saves straight away as a new version, so nothing is lost if it replaces a draft.
    - "Unchanged from the library" ignores translating Yes into the client's own choice wording (e.g. "Compliant").
    - Note for your review: **a control has no classification, so citing one counts as Internal** — an answer that cites only controls is held back until its classification is lowered with a reason (e.g. "describes the control in general terms").
assignee: steve
label:
- feature
priority: high
task_status: review
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