---
id: 01M1HZAEG78E5EZ7NENDHSMS3R
created: 2026-09-02T21:10:10.695607Z
updated: 2026-09-02T21:48:31.649263Z
type: task
title: Notification channels gate on priority, not severity
project: 01KX671DATY39VW6GWK3M2T3DN
number: 769
sprint: s7nj09w
assignee: steve
label:
- improvement
priority: medium
task_status: todo
tech: null
---
`notification_channel.min_severity` is the only "does this reach a human" gate ISE has. After ADR 0110 it filters on the wrong thing.

Severity now sits several steps below the answer: it decides whether a *provider* is impaired, which feeds a capability's state, which combines with Business Criticality to produce a priority. Gating delivery on severity means a channel still cannot tell a flapping synthetic from the call-routing application — the exact complaint the whole redesign exists to fix.

**In scope:** channels gate on **priority**, not severity. Schema, API, the Settings surface, and the delivery path.

**The migration has no honest automatic answer.** Severity and priority are different ladders measuring different things, so `min_severity = medium` does not map onto a priority band. Options are a conservative default (deliver more rather than less, so nothing goes quiet during the change) with the resolved value shown back to the admin, or requiring an explicit choice on first edit. Decide deliberately — a silent remap is how a channel stops delivering and nobody notices.

**Small today, and that is the point.** Two channels exist (`min_severity` of `info` and `medium`), so the change is cheap now and gets more expensive with every channel added.

**Blocked by** the Correlator (ISE-764) — there is no priority to gate on until it computes one.