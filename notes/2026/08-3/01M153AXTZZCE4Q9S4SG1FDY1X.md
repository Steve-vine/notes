---
id: 01M153AXTZZCE4Q9S4SG1FDY1X
created: 2026-08-28T21:10:13.087815Z
updated: 2026-08-28T21:10:45.185254Z
type: task
title: Conditional access as a report subject, and its exclusions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 502
sprint: s5cyp1z
blocked_by:
- 01M153AFZXQAKD75PMWP1Q5BX6
- 01M14W3AV7PF8DFJEKKB4CSEQN
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
Two subjects in the ADR 0062 catalogue on top of COM-501: **the policy**, and **the exclusion** — one row per principal excluded from a policy, which is the one people actually read.

Policy fields: name, state, last modified, what it requires, how many users it covers, how many it excludes. Exclusion fields: the policy, the excluded principal, what kind it is, and — via the existing mirror — whether that account is enabled and whether it holds a directory role.

Seeded definitions:

- **Policies not enabled** — disabled, or left in report-only long after the pilot ended. A control that is claimed and switched off is worse than one that was never claimed.
- **Everyone excluded from a policy**, and **Privileged users excluded from a policy** — the second is the one that matters.
- **Policies changed in the last 30 days** — pairs with the activity log.
- **Applications covered by no policy at all.**

**The report says what is excluded; it never says that is wrong.** Break-glass accounts *should* be excluded, and a report that flags them as findings gets ignored within two runs, taking the genuine exceptions with it. Give the subject a way to mark an exclusion as expected, with a reason and a person's name against it — the same shape as ADR 0061's exception provenance, for the same reason.

If that mark needs to be a first-class record rather than a field, raise it — it is the sort of thing that wants deciding once, not per report.