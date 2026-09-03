---
id: 01M1HZAEG78E5EZ7NENDHSMS3R
created: 2026-09-02T21:10:10.695607Z
updated: 2026-09-03T21:12:33.363607Z
type: task
title: Notification channels gate on priority, not severity
project: 01KX671DATY39VW6GWK3M2T3DN
number: 769
sprint: s7nj09w
comments:
- id: 01M1MHVGTKC3A9CMN8N5DD961V
  author: Steve Vine
  at: 2026-09-03T21:12:33.363408Z
  text: |-
    Built — PR #711 (feature/ise-769-channels-gate-on-priority), migration 0149.

    THE MIGRATION DECISION, TAKEN DELIBERATELY
    The task said there is no honest automatic answer and named two options. I took the first: **a conservative default with the resolved value shown back**. Every existing channel → `P4` (the deliver-more end) and marked `priority_assumed`, which Settings renders as an unresolved choice until somebody confirms it. **Saving the channel IS the confirmation**, whether or not the value changes.

    Why not "require an explicit choice on first edit": its failure mode is a channel that delivers nothing until someone edits it — precisely "a channel stops delivering and nobody notices", which is the thing the task warns about. Deliver-more fails in the direction that gets observed: too many notifications get tuned, too few do not.

    And the volume risk is small in both directions at once: after ISE-764 an incident only opens when the Correlator can price it, so `P4` today delivers a SMALLER set than `min_severity = medium` did yesterday.

    AN INCIDENT WITH NO PRIORITY IS DELIVERED
    Absent is not P4 — nobody computed one — and withholding a notification on the basis of a judgement ISE never made is exactly how a channel goes quiet unnoticed. Same rule one level down: an unrecognised rung on either side delivers. **A routing gate must fail towards being heard.**

    `min_severity` IS RETAINED, NOT DROPPED
    It records what an admin chose, it is what the "assumed" prompt invites them to re-decide against, and dropping a column is the one thing a migration cannot undo. Nothing reads it for routing — and the test that used to assert it gated now asserts that it does NOT, because the thing that would go wrong is somebody wiring it back up.

    The incident card leads with the priority and its reason. A card that leads with severity leads with the source's opinion, and the person reading it at 03:00 is asking ISE's.

    One trap found: the enable/disable toggle sends the whole channel body, so omitting `min_priority` there would silently reset the gate to its default AND clear the assumed flag as a side effect of switching a channel off and on again.
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