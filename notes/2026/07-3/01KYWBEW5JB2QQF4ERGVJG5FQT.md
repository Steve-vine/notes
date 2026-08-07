---
id: 01KYWBEW5JB2QQF4ERGVJG5FQT
created: 2026-07-31T15:07:37.522014Z
updated: 2026-08-07T11:55:25.384339Z
type: task
title: Raise a Freshservice ticket from an incident (one click)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 443
order: 1.03125
sprint: s5pft6a
blocked_by:
- 01KYWBENB8KE28CGV7FDGAZPFA
comments:
- id: 01KYX72QQAQHDST19FXCF0R1XG
  author: Steve Vine
  at: 2026-07-31T23:10:19.881956Z
  text: |-
    Done — PR #390 (stacked on #389), CI green including frontend.

    "Raise ticket" button in the incident header. It POSTs to `/proposed-changes` **with `issue_id` set**, so the change appears inline in the incident's timeline with no new API and no timeline changes — `ActionsPanel` doesn't send `issue_id`, this path must, and there's a test asserting exactly that.

    Submitting **proposes**; it never executes. The modal says so explicitly, because "Raise ticket" sounds like it already happened and an operator shouldn't have to infer that an approver still stands between them and the desk.

    **Degradation is explicit in all three failure cases** — no integration configured, read-only integration, viewer role. Each disables the button *and says why*, on the tooltip and a native `title` so keyboard and screen-reader users get the reason too. A disabled control with no explanation is exactly the case an operator most needs one. With several accounts ISE doesn't guess; with one it doesn't make anyone pick from a list of one.

    The prefilled body **points back at ISE** rather than dumping the timeline — that would be stale the moment the investigation moved on, and the desk agent reading it has no ISE access anyway.

    Two build notes: the body helper moved to `lib/ticketDraft.ts` to clear a `react-refresh/only-export-components` warning, and `Select` uses default portal behaviour (`withinPortal` no longer exists as a prop in this Mantine version — and the ISE-376 gotcha warns against forcing it).

    Verification: 9 component tests; **full frontend suite 466 tests across 82 files**; eslint, prettier, `npm run build` clean.
assignee: steve
priority: medium
task_status: done
---
**The sprint's headline user-facing slice.** An operator looking at an ISE incident raises a service-desk ticket for it without leaving the screen.

Button on `pages/IssueDetailPage.tsx`, in the header group beside `WorkInClaudeButton` (~line 1617) or alongside `ProposeRemediationButton` via the existing `useIssueAction` helper (~line 400). Modal pre-filled from the incident: subject from the title, description from the incident description + a link back to ISE + top signal details.

Posts to `POST /api/v1/proposed-changes` **with `issue_id` set** — the nullable FK already exists on `ProposedChange` and the endpoint already accepts it, so the change appears inline in the incident timeline via `ProposedChangeEventItem` with **no new API and no timeline changes**. (Note: `ActionsPanel` does not send `issue_id` today; this path does.)

Resolves the Freshservice system client-side from the systems list (`connector_type === 'freshservice'`); disabled with an explanatory tooltip when there is none configured, or when it has no `write_credential_ref`. Handle the multiple-configured case.

Renders the created ticket via the `external_ref` anchor added in the create_ticket task, so the operator gets a clickable link to the ticket from the incident timeline.

**This is the clean cut line if the sprint runs long** — the create_ticket task already ships a usable write path with UI via `ActionsPanel`, so dropping this does not leave a backend-only slice.

Frontend Vitest: the button posts `issue_id`, and degrades correctly when no Freshservice system is configured.