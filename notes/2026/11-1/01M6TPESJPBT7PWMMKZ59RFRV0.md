---
id: 01M6TPESJPBT7PWMMKZ59RFRV0
created: 2026-11-07T09:46:54.934971Z
updated: 2026-11-08T08:59:57.907404Z
type: task
title: A check that finds nothing is evidence too — Polaris can write a rule for an empty capture, and a rule that needs every item to pass fails when there are no items, instead of passing on nothing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1628
sprint: s5khbev
comments:
- id: 01M6TVQ8E0E6ENSRQGV2P21PVK
  author: Steve Vine
  at: 2026-11-07T11:18:55.168447Z
  text: |-
    **Done: merged to main in PR #1641. It reaches staging with the rest of sprint 107.**

    **What changed: an empty result is judged, never passed on nothing.**
    - **Every rule says what finding nothing means:** the check fails or passes.
      - Defaults: "every … must" and "at most …" rules fail on nothing; "none may" rules pass, e.g. "no public buckets".
      - So "every branch rule requires review" with no branch rules now **fails**: "No branch rules found, and the rule needs them". Before, it read "All 0 … meet the rule" and passed.
    - **Polaris drafts a rule for an empty capture** rather than refusing. It works from what the check reads and the service's API docs, and always says what finding nothing should mean. "Not collected yet" now appears only when nothing has been collected at all.
    - **Approving a rule:** the proposal says, e.g., "The newest capture found no branch rules. With this rule the check fails." Under it, "If no branch rules are found" lets you choose **The check fails** or **The check passes** before approving.
    - **Approving a first capture with nothing in it** now shows a warning: "GitHub returned nothing for these 2 reads. Approving files that empty answer as evidence…". You know which you're approving.
    - **Rules already approved** are re-judged under the new defaults by the next scheduled checks run.

    **One call I made:** the task said "at most" rules fail on nothing by default. I kept that. "At most 0 public buckets" over nothing would then fail, which you can switch per rule, whereas a silent pass would hide a read that sees nothing. Polaris sets it explicitly on every new rule anyway.

    ADR 0142 is amended.

    **To look at on staging:** SOD.9 ▸ the branch-rules check ▸ Ask Polaris for a rule. Once approved, it should show **Failing** with "No branch rules found…", and raise a gap if SOD.9 is assessed and applicable.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Raised by Steve while testing on staging (2026-11-07). SOD.9 (Test Company) has 6 GitHub checks, all live and collected about 09:25–09:28 UTC. "Ask Polaris for a rule" says: "Polaris couldn't finish. The check hasn't been collected yet, so there's nothing to judge."

## What's going on

- The checks **have** been collected. Five of the six filed captures with **0 items**: no branch rules on main, no rulesets, and no closed pull requests on the repositories read. That is very likely the true answer: these repositories have no rules. For SOD.9 that is the most important evidence there is.
- The rule job (`core/collection/polaris_rule.py` `_prompt`) refuses when the newest captures have no items, and words it as "not collected yet", which is wrong.
- **Worse, in the rule language** (`core/collection/rules.py` `evaluate`): an "every item must…" rule over zero items passes, reading "All 0 branch rules meet the rule". So even with a rule, "this repository has no branch protection" would show as **Passing** and close the gap. It must not.

## Done when

- **Empty means something, and the rule says what.** A rule carries what to do when nothing is judged (no items, or none left after its "which items" filter):
  - **Fails** by default for "every" and "at most" rules: "No branch rules found. Nothing protects main".
  - **Passes** by default for "none may" rules: "No public buckets".
  - Polaris proposes the right one and says it in the rule's sentence. The person sees it and can change it.
- `rules.evaluate` uses it. A test: "every" over [] fails with the "found none" reason; "none" over [] passes; "every" whose filter leaves nothing fails.
- **Polaris can draft a rule for an empty capture.** It works from the check's reads, the item shape in the service's API docs (it can read a page, as the design job does), and what the check says it shows. The rule's preview says "Nothing to judge in the latest capture. With this rule it would fail". It doesn't refuse.
- **The message is right where it does refuse:** "Not collected yet" only when there is no filed capture; otherwise "The latest capture found nothing. Polaris will judge the empty result."
- **Existing approved rules**: any rule already approved is re-judged under the new default, and the change shows in the check's history.
- **Approving the first capture**: when it has 0 items, the approval step says so plainly ("GitHub returned nothing for these 2 repositories") so the person knows an empty capture is being approved.
- On staging: SOD.9's branch-rules check gets a rule, judges the empty capture, shows **Failing** with "No branch rules found", and raises a gap if SOD.9 is assessed and applicable.

## Where

- `core/collection/polaris_rule.py` (`_prompt`, SYSTEM, the rule schema)
- `core/collection/rules.py` (`evaluate`, and the rule's sentence)
- `core/checks/collected.py` (`judge`'s reason wording)
- `collection/RulePanel.tsx`
- The first-capture approval in `collection/CollectionCard.tsx`