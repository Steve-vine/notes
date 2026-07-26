---
id: 01KYEVYM5NCTNDYFPJSNN8GB17
created: 2026-07-26T09:26:28.789768Z
updated: 2026-07-26T09:52:52.128961Z
type: task
title: Advisory playbooks earn efficacy — feedback for priors that guide but don't execute
project: 01KX671DATY39VW6GWK3M2T3DN
number: 303
sprint: svgrad3
assignee: steve
priority: medium
task_status: todo
---
**Sprint 24, live-found (2026-07-26).** The first organically-learned playbook (from IN-1079: `failing_probe` rollout-noise, distilled from a committed diagnosis with no executed change) is **advisory** — hypotheses only, no catalogue operation references. Under the current efficacy rule (`record_playbook_efficacy`, ISE-137/ADR 0029: a point only when the playbook's own operation was executed and the incident closed out), it can never accrue applied/efficacy stats — it reads "Not yet applied" forever, however useful. The diagnose-and-it-cleared class will be common on this estate (rollout noise, self-resolving incidents), so a whole category of priors has no way to demonstrate worth or rot.

Add feedback signals for advisory playbooks, keeping the strict executed-op rule for remediation playbooks untouched:
- **Operator signal**: on the Recall panel, a lightweight "this prior helped / didn't apply" on each matched playbook — one click, recorded like efficacy (helped/not-helped counts alongside success/failure, distinguished in provenance so an advisory score is never conflated with an executed-fix score).
- **Automatic signal (deterministic, optional if cheap)**: when an incident that matched an advisory playbook is resolved with a committed/recorded diagnosis, credit the playbook if its hypothesis matches the diagnosis (start conservative — e.g. only when the diagnosis was committed from a session where the recall was surfaced; avoid crediting coincidence, the same principle the executed-op rule protects).
- **Display**: Playbooks page distinguishes "Not yet applied" (remediation never tried) from advisory standing ("guided N investigations, confirmed M times"); decay/anti-rot applies to advisory scores the same way (a hypothesis repeatedly contradicted by diagnoses should flag for review).

Efficacy ranking in Recall (`efficacy_ratio`) should incorporate the advisory score for advisory playbooks rather than treating them as unproven forever. ADR 0029 gets a note (extends the efficacy model; the judgment-not-privilege boundary is untouched — advisory playbooks reference no operations at all).

Acceptance: the IN-1079 playbook can visibly earn standing from the next probe-flap investigation it guides, on the Playbooks page and in Recall ranking.