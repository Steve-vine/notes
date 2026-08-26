---
id: 01M0YPEVB1XKJW8MBB3FCQTTZ3
created: 2026-08-26T09:29:43.521836Z
updated: 2026-08-26T12:52:09.815789Z
type: task
title: The sidebar says Playbook and Posture — what we intend, and how we're doing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 413
sprint: sbph5q5
comments:
- id: 01M0Z21GNCV6KBRWDN4W9R8D95
  author: Steve Vine
  at: 2026-08-26T12:52:09.515869Z
  text: |-
    Done — PR #416, merged to main.

    The sidebar reads Playbook and Posture. Nothing moved between them and no page changed. Posture is four items rather than five, because COM-408 took Actions out to Overview.

    Two corrections to the implementation note, both worth knowing:

    **`RequireSection section="Library"` did not move.** That prop names the *capability*, not the sidebar heading — it is the gate vocabulary, which the task deliberately left alone. So the route guards are unchanged, and `gate: 'Library'` sitting under `section: 'Playbook'` is intentional. I added a nav test that pins it with the reasoning attached, so it is defended rather than just tolerated.

    **Something user-facing outside the sidebar did use these words.** The refusal message a person sees when they deep-link to a section they cannot read said "You need Company access to view this section" — shown against a heading that now says Posture, that is a puzzle they have no way to solve. The messages name the section as labelled now; the capability names behind them are untouched.

    Also: the portal picked up a new section heading in COM-411, and I named it "Your work" rather than "Overview" partly to keep this vocabulary clean — the test that guarantees the portal never renders the internal navigation works by asserting the internal section names are absent.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: review
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
