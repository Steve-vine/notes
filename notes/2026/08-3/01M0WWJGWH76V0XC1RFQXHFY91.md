---
id: 01M0WWJGWH76V0XC1RFQXHFY91
created: 2026-08-25T16:38:06.481039Z
updated: 2026-08-25T16:38:06.481039Z
type: task
title: Request progress gets an "Approvals" heading — the bare area names stop reading as people
task_status: todo
label: improvement
priority: low
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 403
---
Found in scenario testing (2026-08-25). The Request progress modal opens with "<vendor> · New vendor · Submitted", then drops straight into a list of bare `area_name` + status pills — "Legal (Pending)", "Security (Pending)". Nothing on screen says these are approvals, and read cold the area name looks like a **person's** name, so the list reads as "Legal is pending" rather than "this needs Legal's approval".

The approver's Review modal renders the identical list under a `<Divider label="Approvals" />` and does not have the problem. Give Progress the same heading; the lines themselves stay as they are.

- [ ] `pages/PortalRequestsPage.tsx:335` — a `<Divider label="Approvals" />` above the approvals block, matching `vendors/ReviewModal.tsx:198`. The modal already uses exactly this pattern twenty lines further down (`<Divider label="Conversation" />`), so it is the established shape on this very screen.
- [ ] Render the heading over **both** branches, including "No approvals were required — this went through automatically." Unlike Review's list, that sentence always shows something, and a heading tells the reader what the sentence is answering.
- [ ] Leave the per-line copy alone. Considered "Legal approval (Pending)" and "Approval from Legal (Pending)"; the heading does the explaining once instead of on every row, and it keeps the two surfaces rendering the same line.

- [ ] Test: the heading is present in both the populated and the no-approvals-required states.