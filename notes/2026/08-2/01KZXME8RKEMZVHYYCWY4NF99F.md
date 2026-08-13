---
id: 01KZXME8RKEMZVHYYCWY4NF99F
created: 2026-08-13T13:19:31.091016Z
updated: 2026-08-13T13:52:19.073587Z
type: task
title: A merge candidate you have judged unrelated has no way to go away
project: 01KX671DATY39VW6GWK3M2T3DN
number: 689
sprint: sevhjex
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
The "Looks related to N other incidents" card (`components/MergePanel.tsx`) offers **Merge in** and nothing else. An operator who looks at a candidate and concludes it is genuinely a different incident has no way to say so — `propose_merges` recomputes the same list on every load, so the judgement is thrown away and re-asked forever.

**Wanted:** a dismiss next to each candidate; when the last one is dismissed, the card disappears.

**Scope**
- Per-candidate dismiss control alongside **Merge in**. The card already returns null at `candidates.length === 0` (line 62), so hiding follows for free once dismissed pairs are filtered out of the response.
- Persisted, per-pair. Shares the `issue_suggestion_dismissal` primitive with ISE-688 — one table (issue_id, kind, target_id, actor, at), whichever task lands first owns the migration and the other stacks on it.
- **Decide symmetry explicitly.** "These two are not the same incident" is a fact about the *pair*, not about a direction of viewing. If A dismisses B, B almost certainly should not still propose A — otherwise the operator answers the same question twice from the other end. Recommend symmetric; state the choice in the task's closing note either way.
- Role: **Merge in** is responder-gated (`canMerge`). Dismissing is a smaller act than merging, so it should be no stricter — responder, matching the button beside it. A viewer should see neither.
- The reason string (`c.reason`) explains why ISE proposed the pair; consider carrying it into the dismissal record, so "why was this suppressed" survives.

**Reversibility** — same concern as ISE-688: a durable, invisible dismissal is how a panel silently stops proposing anything. Undo on the toast, or a way to see what was suppressed.

Reported alongside ISE-688 from the incident screen 2026-08-13; the two cards share a defect of shape — ISE proposes, the operator judges, and the judgement has nowhere to go.