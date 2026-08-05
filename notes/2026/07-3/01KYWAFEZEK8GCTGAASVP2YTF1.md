---
id: 01KYWAFEZEK8GCTGAASVP2YTF1
created: 2026-07-31T14:50:28.206287Z
updated: 2026-08-05T11:55:57.796661Z
type: task
title: 'Docs: Concepts — signals &amp; incidents'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 427
order: 0.5
sprint: sp3en5k
comments:
- id: 01KYWB88EBRWCPS2N2184SRR57
  author: Steve Vine
  at: 2026-07-31T15:04:00.715163Z
  text: |-
    Done on feature/ise-427-docs-signals-incidents — PR #22, left OPEN for review.

    Full model: transient/machine-owned signals vs durable/human-owned incidents and why the split exists (absorbing flap); alerts vs observations on the who-owns-"bad" axis with the deferral rule stated; canonical ladder info<low<medium<high<critical with per-connector mapping and the subset/superset rationale; severity-vs-confidence as two deliberate axes; the auto-open rule per kind + "the threshold governs automation only"; a four-row comparison table of the noise controls at their different altitudes (integration-scoped ingest ignore rules, downgrade, ignore, silence) with severity overrides described as scoped/audited/never-mutating-the-connector-default and one-click-from-the-noise; lifecycle New→Active→Resolved→(Reactivated|Closed) with post-Closed recurrence = new incident; deterministic no-AI ingest correlation; escalate-never-de-escalate with the information-vs-judgement reasoning and the "records the worst the estate got" property; implicit acknowledgement incl. the explicit list and what does NOT acknowledge; resolution cascade incl. re-assertion; merge proposed never automatic, children frozen, child escalation lands on master. Facts from ADRs 0025/0026/0032/0035/0038/0040/0044. Build/lint green.
assignee: steve
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/concepts/signals-and-incidents.md` with real content: alerts vs observations; why signals are transient and incidents durable and human-owned; the canonical severity ladder; the auto-incident threshold and confidence bar; escalate-but-never-de-escalate; implicit acknowledgement; silencing vs ignoring vs downgrading (and ingest-time ignore rules, which live on the integration); master/child incidents and merge candidates; recovery and auto-resolution.

Ground in ADRs 0025, 0026, 0032, 0034, 0035, 0036, 0038, 0040, 0044. Operator audience, released capability only.