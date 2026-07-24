---
id: 01KXX7HH90V4MPHG0NFKVQPJ1B
created: 2026-07-19T13:02:42.976915451Z
updated: 2026-07-24T12:50:02.24025Z
type: task
title: Self-tiering — playbook efficacy + short-circuit
project: 01KX671DATY39VW6GWK3M2T3DN
number: 137
sprint: sdv8hgy
blocked_by:
- 01KXX7HBG3ZT3QD8EK1Y34FGH2
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 13 (vertical slice: backend + UI).** Make cost per incident fall as memory grows — the Canon's self-tiering.

- **Backend**: track playbook/memory **efficacy** (did the recalled fix actually work?); compute a **novelty** score for an incident; let a strong, high-efficacy match short-circuit the loop toward a rubber-stamp (fewer/cheaper AI turns). Efficacy decays/updates after each use (anti-rot).
- **UI**: surface **confidence/tier + efficacy trend** on the Recall panel and the Playbooks screen ("high-confidence match — rubber-stamp"; "efficacy 4/5, last used 2d ago").

**DoD**: a repeated identical incident visibly short-circuits (lower AI spend, fewer turns) and its playbook's efficacy updates after the outcome — both visible in the UI. Not done until the tier/efficacy display and the short-circuit are observable.

Depends on Update.