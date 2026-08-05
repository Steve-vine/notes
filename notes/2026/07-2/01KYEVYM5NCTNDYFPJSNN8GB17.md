---
id: 01KYEVYM5NCTNDYFPJSNN8GB17
created: 2026-07-26T09:26:28.789768Z
updated: 2026-08-05T14:25:24.469272Z
type: task
title: Advisory playbooks earn efficacy — feedback for priors that guide but don't execute
project: 01KX671DATY39VW6GWK3M2T3DN
number: 303
sprint: svgrad3
comments:
- id: 01KYF0XSCXZPF39G89A9D766J3
  author: Steve Vine
  at: 2026-07-26T10:53:24.252946Z
  text: |-
    Implemented — PR #271 (feature/ise-303-advisory-playbook-efficacy), stacked on #270.

    The efficacy model is EXTENDED, not loosened:
    - Two separate ledgers. playbook.efficacy_* (executed-op rule) is untouched. Advisory feedback lives in a new playbook_feedback table (migration 0055), one verdict per playbook×incident — so an advisory score is never conflated with a proven-fix score. Provenance is structural (a source column: operator/auto).
    - Operator signal (primary): one-click Helped/Didn't-apply on each advisory match in Recall. POST /playbooks/{id}/feedback (operator; 400 for a remediation playbook — those are scored by executed fixes only). Idempotent per incident (upsert, one verdict). helped=false is the anti-rot signal so advisory scores decay too.
    - Automatic signal: conservative + positive-only. On resolve WITH a diagnosis on record, credit a matched advisory playbook only when the diagnosis bears out its hypothesis (shared distinctive words, ≥2, not a bare kind-match). Never auto-penalises (a kind-match that was really a different cause isn't the playbook's fault — that's the operator's call), never overwrites an operator verdict.
    - Ranking: ranking_ratio scores remediation playbooks by executed efficacy, advisory ones by feedback standing — so an advisory prior that keeps helping rises in Recall instead of sitting at the neutral prior forever.
    - Display: Playbooks page + Recall show "guided N · confirmed M" for advisory playbooks instead of "not yet applied".

    Judgment-not-privilege untouched — advisory playbooks reference no operations, so this only changes how a playbook earns standing, never what it can do. ADR 0029 note added.

    Acceptance met: the IN-1079-style advisory playbook now visibly earns standing from the next probe-flap investigation it guides, on the Playbooks page and in Recall ranking — both via the operator one-click AND the automatic diagnosis-confirms credit.

    Tests: backend model+migration (models-match green) + service + API integration tests; ruff + mypy strict (322 files). Frontend advisory badge + Recall feedback tests + full suite 411 + build. Moving to review; deploying to staging with ISE-302 now.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 24, live-found (2026-07-26).** The first organically-learned playbook (from IN-1079: `failing_probe` rollout-noise, distilled from a committed diagnosis with no executed change) is **advisory** — hypotheses only, no catalogue operation references. Under the current efficacy rule (`record_playbook_efficacy`, ISE-137/ADR 0029: a point only when the playbook's own operation was executed and the incident closed out), it can never accrue applied/efficacy stats — it reads "Not yet applied" forever, however useful. The diagnose-and-it-cleared class will be common on this estate (rollout noise, self-resolving incidents), so a whole category of priors has no way to demonstrate worth or rot.

Add feedback signals for advisory playbooks, keeping the strict executed-op rule for remediation playbooks untouched:
- **Operator signal**: on the Recall panel, a lightweight "this prior helped / didn't apply" on each matched playbook — one click, recorded like efficacy (helped/not-helped counts alongside success/failure, distinguished in provenance so an advisory score is never conflated with an executed-fix score).
- **Automatic signal (deterministic, optional if cheap)**: when an incident that matched an advisory playbook is resolved with a committed/recorded diagnosis, credit the playbook if its hypothesis matches the diagnosis (start conservative — e.g. only when the diagnosis was committed from a session where the recall was surfaced; avoid crediting coincidence, the same principle the executed-op rule protects).
- **Display**: Playbooks page distinguishes "Not yet applied" (remediation never tried) from advisory standing ("guided N investigations, confirmed M times"); decay/anti-rot applies to advisory scores the same way (a hypothesis repeatedly contradicted by diagnoses should flag for review).

Efficacy ranking in Recall (`efficacy_ratio`) should incorporate the advisory score for advisory playbooks rather than treating them as unproven forever. ADR 0029 gets a note (extends the efficacy model; the judgment-not-privilege boundary is untouched — advisory playbooks reference no operations at all).

Acceptance: the IN-1079 playbook can visibly earn standing from the next probe-flap investigation it guides, on the Playbooks page and in Recall ranking.