---
id: 01KXKX4EBN31N1XFY4X2GQAM0B
created: 2026-07-15T22:07:38.357145304Z
updated: 2026-07-21T09:54:04.512992Z
type: task
title: Remediation summary not shown on issue when no changes proposed
project: 01KX671DATY39VW6GWK3M2T3DN
number: 83
sprint: syqgx3z
priority: medium
task_status: done
---
Running "propose remediation" on an issue shows nothing on the issue screen when the agent proposes no changes — its rationale only appears in Agent Runs. Diagnose, by contrast, always renders on the issue. From the operator's view it looks like nothing happened.

**Root cause — asymmetric persistence:**
- Diagnose writes its result onto the issue (`ai/diagnosis.py:50` → `issue.evidence.diagnosis`); the page reads it off the issue object (`IssueDetailPage.tsx` DiagnosisPanel, `lib/diagnosis.ts:39-53`). Always renders.
- Propose-remediation persists only actionable `ProposedChange` rows (`ai/remediation.py:58-101`) and stashes the proposal-level `summary` in `AgentRun.outcome` only (`ai/agents.py:284-287`). The issue page's ProposedChangesPanel queries proposed-changes and returns null when `changes.length === 0` (`IssueDetailPage.tsx:185`), and never reads the summary. So a no-change proposal surfaces nowhere on the issue.

**Why it matters:** the no-change case is valuable — the agent explaining why it won't act (e.g. muting a Datadog event would mask a live incident) is exactly what an operator should see on the issue, not a click away in Agent Runs.

**Fix direction:** surface the remediation `summary` on the issue regardless of whether changes were proposed — mirror the diagnose pattern (persist onto the issue) or have the frontend read the latest propose-remediation AgentRun summary even when `changes` is empty.