---
id: 01M0PTC4CC1RBG5PQ7MS35EX02
created: 2026-08-23T08:04:13.324705Z
updated: 2026-08-23T11:47:53.950925Z
type: task
title: Portal Requests list shows what was asked — summary sub-rows under each request
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 376
sprint: sbph5q5
comments:
- id: 01M0Q75EFYEH6EC91ZT2E15BZB
  author: Steve Vine
  at: 2026-08-23T11:47:45.790363Z
  text: |-
    Done — PR #385, merged to main as c91883a.

    `core/vendor_request_summaries.py` composes the lines; `VendorOnboardingRequestOut.summary` carries them, so the internal Requests queue already has the same sentences rather than "later". Rendered as indented child rows using the existing `[data-group-row]` rules, display-only, actions left on the parent. The table lost `striped` — the parent/child colouring *is* the stripe, and two schemes over the same rows read as a rendering bug.

    **The "from" side: I took your recommendation, the snapshot.** `vendor_onboarding_requests.engagement_snapshot` (migration 0102), written at submission for **every** kind — the before side for an amendment, what was asked for otherwise. Reading current values would have meant a request decided in March describing itself differently in September. Names, not ids, for data types and entities: a snapshot exists to say what was true then, and resolving ids later shows today's name against yesterday's decision. Rows raised before the column fall back to the engagement as it stands rather than backfilling something that would claim to be a snapshot it is not.

    ADR 0040 has the amendment, including why this JSONB is not the JSONB §4 refused — no rule reads it, nothing is written back from it, no form renders it, and it never crosses the API; only the sentences do.

    An end-to-end test pins the point: approve an amendment, and its summary still reads "from Hosting to Hosting + backups" rather than collapsing to "from X to X" once the engagement has moved.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
The portal's My Requests list (`PortalRequestsPage.tsx`) is a flat table — Vendor / Kind / Status / Submitted — with nothing saying *what* was requested. Add a subsection under each request summarising the ask in plain sentences.

## Content

- [ ] **Server-composed summary lines** per request (one place builds the sentences; the client renders strings — the internal Requests queue can reuse them later):
  - `new_vendor` → "Requested new vendor "X"" plus notable proposed fields (criticality, engagement it arrives with)
  - `new_engagement` → "Requested new engagement "Y"" plus its key facts (annual cost, data types)
  - `amend_engagement` → field-level lines, "Changed annual cost from £12,000 to £8,000", one line per proposed field
- [ ] **Decide the "from" side for amendments**: proposal vs the engagement's *current* values (cheap, drifts if the engagement changed since) or a before-snapshot taken at request creation (honest history, small column). Recommend the snapshot — a decided request's summary should not change meaning after the fact.
- [ ] Money/dates formatted as elsewhere (the £ formatting the engagements card uses); select-kind values by label.

## Presentation

- [ ] The Register's grouped-row pattern is the model: request row as `data-group-row="parent"` (main title colour), summary lines as indented `data-group-row="child"` rows in the dimmed/smaller child format — reuse the existing `[data-group-row]` rules in `index.css`, don't invent a second scheme.
- [ ] Keep the table scannable: child rows are display-only (no actions); the existing per-request actions/transcript link stay on the parent.

- [ ] Tests: each kind renders its lines; amendment shows one line per changed field with both values; formatting of money; parent/child row semantics in the DOM.