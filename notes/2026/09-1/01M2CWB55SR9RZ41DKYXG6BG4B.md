---
id: 01M2CWB55SR9RZ41DKYXG6BG4B
created: 2026-09-13T07:57:37.849101Z
updated: 2026-09-13T07:57:43.835515Z
type: task
title: A superseded decision cannot be linked to anything — pickers hide it and the API refuses it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 700
sprint: skdc1az
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Requested by Steve, 2026-09-13: it must not be possible to link a **superseded** decision to any record — assets or otherwise. A superseded decision is history; the current decision is the one that should be cited.

**Where links are made** (all go through one endpoint, `POST /api/v1/decisions/{number}/links` in `api/v1/decisions.py`, which today checks only that the target exists):
* **API**: `link_target` refuses when `record.status` is `superseded` — 409 `conflict`, "Decision D-12 is superseded by D-19 and cannot be linked; link D-19 instead" (naming the superseding record when it is known). Also refuse **declined** — a proposal that was rejected is not a decision anyone should cite either; same message shape. Proposed and accepted remain linkable. Say in the PR that declined was included by the same reasoning, so Steve can strike it.
* **Pickers**: `LinkedDecisions` (`components/LinkedDecisions.tsx`, `useDecisions()` filtered) — the shared picker used by controls, risks, content, vendors and the three asset registers — excludes superseded and declined decisions from its options. The status pill on options stays for proposed vs accepted.
* **The decision side**: on a superseded decision's detail page the *Link…* affordances are hidden/disabled with the same wording; its existing links remain visible and read-only.
* **Existing links** to decisions that are now superseded are kept — they are history and the superseding decision carries the rationale. Where such a link renders (the *Linked decisions* card on any record) it shows the pill *Superseded* and, when known, "→ D-19".
* **Superseding a decision** (the existing `supersede` action, `decisions.py` ~L219–240) does not move links; a follow-up may offer "carry links forward" — out of scope here, note it in the PR.
* ADR 0029 (decision lifecycle) or ADR 0072 §13 gets a one-line amendment: terminal decisions are not linkable.

Tests: API refuses superseded and declined, accepts proposed and accepted; picker options exclude them; a record with an old link to a now-superseded decision still renders it with the pill.

**Acceptance**: a superseded decision does not appear in any Link decision picker; posting the link directly is refused with the message; existing links to superseded decisions still show, marked Superseded.