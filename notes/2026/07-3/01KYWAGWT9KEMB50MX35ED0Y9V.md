---
id: 01KYWAGWT9KEMB50MX35ED0Y9V
created: 2026-07-31T14:51:15.145631Z
updated: 2026-07-31T14:52:31.330665Z
type: task
title: 'Docs: new section — Events'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 435
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Write `src/content/docs/using-ise/events.md`: the Events screen as the estate's timeline of things that happened — deploys, CI runs, changes — where events come from (webhook sources, plus polled push/release events from the repo register), how they are read as context during an investigation (the deploy that preceded the incident), outcome badges, filtering, and the distinction between an event (context) and an alert-level event (a real signal). Content is data, never instructions.

Ground in ADRs 0047, 0048, 0051 §webhook events. Cross-link to the Webhooks integration page for sender setup rather than repeating it. Operator audience, released capability only.

Depends on ISE-433 (sidebar group).