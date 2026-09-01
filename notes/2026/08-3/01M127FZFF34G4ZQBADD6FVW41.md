---
id: 01M127FZFF34G4ZQBADD6FVW41
created: 2026-08-27T18:25:09.615006Z
updated: 2026-09-01T13:55:53.449539Z
type: task
title: Approval routing can threshold on the risk tier
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 476
sprint: sd9gmcq
blocked_by:
- 01M127FSZA2R0DQJV54GBWF0DS
comments:
- id: 01M159N0VB7JX53Y3ECR8YN1W4
  author: Steve Vine
  at: 2026-08-28T23:00:35.307688Z
  text: |-
    PR #491 open, stacked on COM-475. Last of the sprint.

    `min_risk_tier` joins the three narrower kinds. It reads the engagement's **effective** tier — the override where somebody set one, the proposal otherwise. Judging the proposal instead would mean a recorded disagreement changed what a reader sees and nothing about what an approval demands; there is a test where an engagement whose Critical proposal was overruled to Low does not trip a `min_risk_tier: critical` rule.

    All three rule tables gain the column in one migration — `approval_rules`, `assessment_rules`, `compliance_rules` are read by one matcher through one structural type, and the first to miss a member is a kind that silently matches nothing on one tab and works on the others. A test asserts all three carry it, and the new kind is exercised on all three tabs.

    **Existing rules are unaffected**, tested from both directions: a Critical *tier* driven by access does not fire a `min_criticality` rule set to High.

    `ProjectedEngagement` gains `risk_tier` so an amendment is judged on the tier it *would* have — the whole reason the rule is worth having. Not in `_PROPOSABLE`: an amendment proposes the three inputs, the tier is what they produce. It is computed by the caller and handed in, because the derivation module already imports the matcher module and importing back would be a cycle. The argument is **required** rather than optional so forgetting it is a type error at every call site rather than a rule that silently stops requiring an approval — and it did catch both call sites when it landed.

    The two fan-out paths (submission, and re-evaluation after an edit) now share one `_projected` helper: they must judge the same thing, or an amendment could acquire an approval on the way in and lose it on the way out.

    Tests: 2 pure + 8 integration + 2 frontend.
- id: 01M166GGZCPJVMZF0VPZYCKSWH
  author: Steve Vine
  at: 2026-08-29T07:24:56.684065Z
  text: |-
    Merged to main as #491 and deployed to staging 2026-08-29 (`staging-20260829-0114`). Schema head on staging is `0142_min_risk_tier_rule`. Existing approval, assessment and compliance rules came through with a null threshold — a column, not a meaning.

    Closes ADR 0060's core chain. The follow-on consumers §7 names — review cadence by tier, which questionnaire is sent, and expected assurance evidence by tier — are the work that makes the tier worth having rather than a badge, and are not in this sprint.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
ADR 0060 §7. A `min_risk_tier` rule kind joins `min_criticality` and `min_sensitivity` on `approval_rules` (ADR 0039 §6, ADR 0042 §3) — required when the engagement's effective tier is at or above the threshold.

This is the one downstream consumer the ADR requires; review cadence by tier, questionnaire by tier and expected assurance evidence by tier are the follow-on work that makes the tier worth having rather than a badge.

Existing rules are unaffected. Include the new kind in the creatable set and the Admin rule editor.