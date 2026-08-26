---
id: 01M0YPEVB1XKJW8MBB3FCQTTZ3
created: 2026-08-26T09:29:43.521836Z
updated: 2026-08-26T09:29:46.857362Z
type: task
title: The sidebar says Playbook and Posture — what we intend, and how we're doing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 413
sprint: sbph5q5
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: todo
---
Two of the sidebar headings describe where data lives rather than what you
would go there to do. **Library** is a shelf. **Company** distinguishes
nothing — everything in Compass is per-company, vendors and access included.

Renamed, they say what Compass is for: here is what we intend, here is how we
are actually doing.

## What changes for the reader

- **Library → Playbook** — frameworks, domains, controls, content.
- **Company → Posture** — assessments, gaps, risks, decisions.

Nothing moves between them and no page changes. Labels only.

**Posture** is the word the product already uses for this exact idea — the
Dashboard is described as "company posture at a glance", and a vendor's
compliance status is documented as its assurance posture. The nav now agrees
with the writing instead of using a third vocabulary.

Reads as a pair: *Playbook* / *Posture*.

Note this lands after COM-408, which moves Actions out of this section to
Overview — so Posture is four items, not five.

## Implementation

`components/nav.ts` — `NavSection` becomes
`'Overview' | 'Playbook' | 'Posture' | 'Modules' | 'Portals' | 'Admin'`,
with `SECTION_ORDER` and `SECTION_GATE` following. The section names are
rendered directly as headings, so the type rename *is* the label change.

`NavGate` is a separate vocabulary and is **not** part of this. Its members
name capability sets (`canWriteLibrary`, `require_library_write`, the
`_LIBRARY_*` frozensets on the backend), which are not what this task is
renaming. Leaving `gate: 'Library'` under `section: 'Playbook'` reads oddly
for one commit; renaming the capability vocabulary as well is a much larger,
API-visible change and does not belong here. Add a comment saying so, or the
next reader will assume it was an oversight.

Two call sites read section names as strings and need to move with the type:
`App.tsx`'s `<RequireSection section="Library" />` route guard, and the
comment above it. `tsc` will find them.

Check for a section name in `AppLayout` tests and in any nav snapshot.

Nothing user-facing outside the sidebar refers to either word — the role
labels name roles, not sections — so the blast radius is the sidebar and the
route guard.
