---
id: 01KZXMDTQ3FC2VD3KYCF3XJ1MW
created: 2026-08-13T13:19:16.707737Z
updated: 2026-08-13T16:38:49.13343Z
type: task
title: '"Didn''t apply" votes on a playbook but never dismisses it — the Recall card comes back forever'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 688
sprint: sevhjex
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
On the incident screen, clicking **Didn't apply** on every playbook in the "ISE has a playbook for this" card leaves the card exactly as it was. It returns on every visit.

**Cause — one button answering the wrong question.** `Didn't apply` (`IssueDetailPage.tsx:1412`) POSTs `/playbooks/{id}/feedback` with `helped: false`, which records *advisory standing* — a global judgement on the playbook's quality (ISE-303). It says nothing about **this** incident, and Recall re-matches by signature on every render, so the row reappears. The operator means "not relevant here"; the button hears "this playbook is bad everywhere". Same shape as ISE-630 — one name serving two questions.

**Wanted:** dismissing every playbook removes the card from this incident permanently.

**Scope**
- Per-incident, persisted dismissal of a playbook suggestion. See ISE-689 — both cards need the same primitive, and one `issue_suggestion_dismissal` table (issue_id, kind, target_id, actor, at) should serve both rather than two near-identical tables. Whichever task is built first owns the migration; the other stacks on it.
- `Didn't apply` does BOTH: keeps recording the advisory verdict (it is genuine quality signal) and dismisses the row here. One click, both meanings — that is what the operator intends, and splitting it into two buttons would be worse.
- **Every row needs a dismiss, not just advisory ones.** Today the button renders only for `pb.is_advisory && canVote` (line 1396), so a remediation playbook has no dismissal at all and would keep the card alive on its own. Dismissal is available on every row; *feedback* stays advisory-only.
- Recall filters dismissed playbooks out of its response, so the card's existing `playbooks.length` logic hides them without further change.

**Do not hide the whole card unconditionally.** It is dual-purpose: with `prior_count > 0` it is titled "Seen N times before" and carries prior history, which has nothing to do with playbooks. The rule is: render when there are priors OR undismissed playbooks; when both are empty, fall through to the existing "No prior history" line. The title Steve reported against — "ISE has a playbook for this" — only appears when `prior_count === 0`, so in that case dismissing them all does empty the card, exactly as asked.

**Reversibility.** A dismissal is durable and invisible once made, which is how a card quietly stops working and nobody knows why. Either surface dismissed suggestions behind a "show dismissed" affordance, or make the toast undoable. Decide explicitly rather than by omission.