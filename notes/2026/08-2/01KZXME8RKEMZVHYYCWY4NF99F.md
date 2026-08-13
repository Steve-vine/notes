---
id: 01KZXME8RKEMZVHYYCWY4NF99F
created: 2026-08-13T13:19:31.091016Z
updated: 2026-08-13T17:31:48.75732Z
type: task
title: A merge candidate you have judged unrelated has no way to go away
project: 01KX671DATY39VW6GWK3M2T3DN
number: 689
sprint: sevhjex
comments:
- id: 01KZY2W671GCMK4A61D1SGM7F2
  author: Steve Vine
  at: 2026-08-13T17:31:47.297195Z
  text: |-
    2026-08-13 — DONE, PR #640 merged to main. Stacked on ISE-688; no new migration.

    **Symmetry: SYMMETRIC, as recommended.** Stating the choice explicitly as the task asked. "These two are not the same incident" is a fact about the *pair*, not about which end you were viewing from. Written one-way, incident B would go on proposing A and the operator would answer the same question twice from the other side — which is the exact waste the feature exists to remove. So `POST /issues/{a}/dismissals` with `kind=merge_candidate` writes **both** rows, and `DELETE` removes both: a half-restored pair, reappearing on one incident while staying suppressed on the other, is worse than either consistent state. Two integration tests assert both directions.

    **Role: responder**, matching `canMerge` rather than exceeding it — dismissing is a smaller act than merging, so it is gated no more strictly than the button beside it. A viewer sees neither, asserted in a test.

    **The reason is carried into the record**, as suggested. `c.reason` (why ISE proposed the pair) goes into the dismissal row and is shown back beside who overruled it — "same entity, 4 minutes apart · dismissed by desk@example.com". By the time anyone asks "why was this suppressed", the proposal that prompted it is long gone.

    **Reversibility**, same shape as ISE-688: dismissed pairs are served rather than merely filtered, behind "N judged unrelated — show", each with a Restore. The card's null-return condition became `candidates.length === 0 && putAway.length === 0` — so dismissing the last candidate still makes the card disappear exactly as asked, but only once there is also nothing being held back.

    **One test worth calling out: the kind boundary.** One table now serves two kinds, and the only thing keeping them apart is the `kind` filter on read. A bug there would silently suppress the *wrong* suggestions — a playbook dismissal hiding a merge candidate — with no error anywhere. `test_a_playbook_dismissal_does_not_leak_into_merge_candidates` pins it.

    **Sequencing note for the record:** #640 was opened stacked on #639, then retargeted to main and rebased with `git rebase --onto origin/main <parent-tip>` after #639 squash-merged. The first attempt used the squash commit's SHA as the old base and conflicted — the old base must be the **parent branch tip in your own history**, not the commit main ended up with. Worth remembering; the two are never the same commit under squash-merge.

    3 backend integration tests + 3 frontend, all green. Full PR CI green (backend 9m29s).
assignee: steve
label:
- improvement
priority: medium
task_status: review
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