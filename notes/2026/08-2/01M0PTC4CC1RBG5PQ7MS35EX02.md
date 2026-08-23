---
id: 01M0PTC4CC1RBG5PQ7MS35EX02
created: 2026-08-23T08:04:13.324705Z
updated: 2026-08-23T08:04:13.324705Z
type: task
title: Portal Requests list shows what was asked — summary sub-rows under each request
priority: medium
assignee: steve
label: improvement
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 376
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