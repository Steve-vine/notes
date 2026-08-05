---
id: 01KYWAGWT9KEMB50MX35ED0Y9V
created: 2026-07-31T14:51:15.145631Z
updated: 2026-08-05T13:25:56.806721Z
type: task
title: 'Docs: new section — Events'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 435
order: 0.00048828125
sprint: sp3en5k
blocked_by:
- 01KYWAGFZMYHV2Y0WHXM8W7N8G
comments:
- id: 01KYWBTZ9DG43A7YEQ0GC7W111
  author: Steve Vine
  at: 2026-07-31T15:14:13.933845Z
  text: |-
    Done on feature/ise-435-docs-events — PR #30 (stacked on ISE-434), left OPEN for review.

    Opens on the framing that makes the screen legible: "signals tell you something is wrong; events tell you what happened" with the eight-minutes-earlier deploy as the motivating case. Covers sources (webhook sources with the tokened URL, plus polled push/release from the repo register landing on the SAME screen — no separate surface); reading the screen (title, sender-defined free-text type, outcome badges, sender timestamp vs ISE received-at, markdown body, unknown fields preserved verbatim, filters, and the real usage pattern); events vs alerts as literally one field, with alert-level getting the full ladder/dedup/threshold/correlation treatment identical to a DataDog monitor, plus the push-source recovery story (explicit recovery event or per-source TTL — "a source that goes silent never leaves a signal firing forever"); and the data-never-instructions posture stated plainly with the same-as-evidence-and-documents link. Cross-links to the webhooks integration page for setup rather than duplicating. 23 pages build. Facts from ADRs 0047/0048/0051.
assignee: steve
label: null
priority: medium
task_status: done
---
Write `src/content/docs/using-ise/events.md`: the Events screen as the estate's timeline of things that happened — deploys, CI runs, changes — where events come from (webhook sources, plus polled push/release events from the repo register), how they are read as context during an investigation (the deploy that preceded the incident), outcome badges, filtering, and the distinction between an event (context) and an alert-level event (a real signal). Content is data, never instructions.

Ground in ADRs 0047, 0048, 0051 §webhook events. Cross-link to the Webhooks integration page for sender setup rather than repeating it. Operator audience, released capability only.

Depends on ISE-433 (sidebar group).