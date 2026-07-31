---
id: 01KYWBEW5JB2QQF4ERGVJG5FQT
created: 2026-07-31T15:07:37.522014Z
updated: 2026-07-31T15:16:21.042806Z
type: task
title: Raise a Freshservice ticket from an incident (one click)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 443
order: 1.03125
sprint: s5pft6a
blocked_by:
- 01KYWBENB8KE28CGV7FDGAZPFA
assignee: steve
priority: medium
task_status: todo
---
**The sprint's headline user-facing slice.** An operator looking at an ISE incident raises a service-desk ticket for it without leaving the screen.

Button on `pages/IssueDetailPage.tsx`, in the header group beside `WorkInClaudeButton` (~line 1617) or alongside `ProposeRemediationButton` via the existing `useIssueAction` helper (~line 400). Modal pre-filled from the incident: subject from the title, description from the incident description + a link back to ISE + top signal details.

Posts to `POST /api/v1/proposed-changes` **with `issue_id` set** — the nullable FK already exists on `ProposedChange` and the endpoint already accepts it, so the change appears inline in the incident timeline via `ProposedChangeEventItem` with **no new API and no timeline changes**. (Note: `ActionsPanel` does not send `issue_id` today; this path does.)

Resolves the Freshservice system client-side from the systems list (`connector_type === 'freshservice'`); disabled with an explanatory tooltip when there is none configured, or when it has no `write_credential_ref`. Handle the multiple-configured case.

Renders the created ticket via the `external_ref` anchor added in the create_ticket task, so the operator gets a clickable link to the ticket from the incident timeline.

**This is the clean cut line if the sprint runs long** — the create_ticket task already ships a usable write path with UI via `ActionsPanel`, so dropping this does not leave a backend-only slice.

Frontend Vitest: the button posts `issue_id`, and degrades correctly when no Freshservice system is configured.