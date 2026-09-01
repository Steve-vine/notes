---
id: 01M153AXTZZCE4Q9S4SG1FDY1X
created: 2026-08-28T21:10:13.087815Z
updated: 2026-09-01T13:55:52.296813Z
type: task
title: Conditional access as a report subject, and its exclusions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 502
sprint: s5cyp1z
blocked_by:
- 01M153AFZXQAKD75PMWP1Q5BX6
- 01M14W3AV7PF8DFJEKKB4CSEQN
comments:
- id: 01M1715RQV9Z58QS1M57N4WBFV
  author: Steve Vine
  at: 2026-08-29T15:10:55.73912Z
  text: |-
    Done — PR #512, merged to main (278798c).

    Two subjects on top of COM-501: the policy, and the exclusion. Every field is derived from the rule Graph sent rather than a column the sync decided — which is what COM-501 stored the rule whole for.

    **On the raised question: yes, the mark needs to be a first-class record, and it is one.** The mirror settles it. Exclusion rows are current-state facts reconciled on every 15-minute pass — deleted and rewritten whenever a policy changes — so a field on one would be wiped by the next sync. It is keyed on the policy-and-principal pair rather than on the exclusion row, so it survives a principal being excluded, un-excluded and excluded again: "why is this account outside the policy" has the same answer either way. Audited, and the reason is required — a mark with no reason is a way of making a finding disappear, which is exactly what it exists to prevent.

    The report says what is excluded; it never says that is wrong. An exclusion nobody has explained reads as "nobody has said why" — a question, not a verdict.

    Also worth knowing: exclusions and inclusions live in one table with a flag, so the Exclusions subject is a *view*. Rather than trusting each report to remember the filter, the catalogue gained a subject-level base filter the runner applies alongside company scoping — a definition that forgot it would answer the opposite question and look right.

    Five new reports: policies not enabled, everyone excluded from a policy, privileged users excluded from a policy, policies changed in the last 30 days, and applications covered by no policy at all.

    One correction I made while building it: with no conditional access mirrored — which is what a missing Policy.Read.All looks like — "covered by no policy" would have reported every application in the tenant as a finding. It now reads as unknown until at least one enforced policy is mirrored, so the report returns nothing and Admin → Integrations says why.

    **New screen: Access Control → Conditional Access.** It exists because nothing in a report can put a reason anywhere. It lists the policies with what each requires and how many it exempts, and the exclusions with the explanation beside each — privileged ones badged, a principal Compass cannot name listed under its object id rather than dropped, and Mark as expected / Reword / Withdraw for anyone who can write access. Read-only otherwise.

    Smoke test: Access Control → Conditional Access (needs the Policy.Read.All consent from COM-501), and the five new definitions under Reports.
assignee: steve
label:
- feature
priority: medium
task_status: done
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