---
id: 01M1J1DYX8NFKNSFEHCA1EPRH6
created: 2026-09-02T21:47:02.952924Z
updated: 2026-09-05T13:31:04.926385Z
type: task
title: 'Describe the estate: the first real pass at Business Applications'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 771
sprint: s7nj09w
assignee: steve
label:
- chore
priority: high
task_status: done
tech: null
---
Everything above the Correlator now depends on definitions that do not exist. **2 Business Applications and 1 Business Service against ~6,000 live entities.** ADRs 0108-0111 give the machinery; none of it produces a judgement until somebody says what things are.

This is authoring work, not code. It needs business knowledge, so it cannot be delegated to the tooling that consumes it.

**Start where the noise is, not where the estate is.** Describing 6,000 entities is not the job and never will be. The payoff is immediate and largest on whatever currently generates the most signal — on staging that is `monitor_alert` (99 incidents), `app-credential-expiry` (53) and `claude` (26). Describe the applications those land on and the same volume starts arriving with a priority instead of a severity.

**A described Business Application means:**
- Business Criticality set (ADR 0110 — unset raises an Observation rather than defaulting)
- Business Application Context — a paragraph on what it is and what it does
- Membership that is right: tag rules where tags work, directly-named entities where they do not
- Capabilities for what actually matters — a named need and its providers, best first. Not every member; the ones whose failure means something
- Entity Context on the members worth describing

**Partly startable today.** Entity Context (the `business` annotation) has a table, an API and an editor already, and Business Application rules already work. Only capabilities and criticality wait on ISE-765. Membership and context can be written now, and the earlier they exist the more the build has to test against.

**The measure is coverage, not count.** ADR 0110 §6 reports signals landing outside every Business Application. That figure — which starts out terrible and honestly so — is the number that says how far this has got. The incident count is not.

**Watch:** 198 proposals sit unworked and are the mechanism that would seed much of this. Working that queue is part of the job rather than a separate one.