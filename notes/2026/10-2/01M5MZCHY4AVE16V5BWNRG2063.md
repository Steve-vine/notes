---
id: 01M5MZCHY4AVE16V5BWNRG2063
created: 2026-10-23T18:11:50.34074Z
updated: 2026-10-24T10:56:26.658353Z
type: task
title: Controls are Public in a DDQ — what a control says can be given to anyone, while how the company is doing against it (status, maturity, notes) is Internal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1273
sprint: shig2cj
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 85, DDQ-2. From Steve's review of sprint 84 (2026-10-23): "Not having the controls is very limiting. I think the controls themselves need to be public with the control assessment (status, maturity, notes) should be internal."

**Chain:** on the chain (API; a migration only if the classification is stored)

## Why

In sprint 84 a control has no classification, so it counts as Internal and is never shared. Any answer that cites a control is held back until someone lowers the answer's classification with a reason. Controls are the most natural thing to answer a DDQ from ("Do you enforce MFA?" → the access control), so almost every answer hits this.

## What people see

- **A control is Public.** Citing one as a source, or getting it as a suggestion, shows "Can be given" on any DDQ, with or without an NDA. An answer whose only sources are controls defaults to Public and can be approved straight away.
- **The company's assessment of a control is Internal.** Its status, maturity level and assessment notes can be cited as a source, but they count as Internal: held back under the starting rules, unless the answer's classification is lowered with a reason, the Internal rule is changed in the rubric, or an Admin releases it.
- In the answer form's source picker, a control and its assessment are two separate choices: "AC.3 — Multi-factor authentication (Public)" and "AC.3 assessment — Implemented, maturity 3 (Internal)".
- The assistant's source search returns them the same way, so it drafts from the control's wording and knows the assessment detail would be held back.
- The evidence pack and completed questionnaire follow the same rules. A control isn't a file, so nothing new goes in the pack.

## My calls (for Steve to confirm)

1. **Every control is Public, by rule.** This isn't a classification set per control. If some controls should be more sensitive, that would be a per-control classification, a larger change.
2. **"Internal" for the assessment means a citable source classified Internal**, not a banned one. ADR 0124 call 8 said assessment results are never sources; this amends that for control assessments. Gaps and risks stay never-sources.
3. **Existing answers that cite controls** are re-judged live (sharing is worked out on every read). Draft answers whose classification was defaulted from a control drop to Public on their next save. Approved answers keep the classification they were approved with. Sent DDQs are frozen and unchanged.

## Notes (technical)

- `core/answer_links.source_classification`: a `control` source returns Public's rank (look up by position on the scale, as "unclassified = Internal" does, not by name). Add source kind `control_assessment` (target: the company's assessment of a CoreControl.key) returning Internal's rank. Remove `assessment` from `NEVER_SOURCES` only for this new kind; gap and risk stay refused.
- The label is frozen at citing time, e.g. "AC.3 assessment — Implemented, maturity 3". The snapshot at sending (COM-1263) records status, maturity and notes as they were.
- Pickers: `link_options` for answers and library entries; the assignee page (COM-1258) filters assessments by what the person can see (posture view).
- Assistant: `ddq_find_answer_sources` returns control and control-assessment rows with `may_share`; update the descriptions that say controls count as Internal.
- An ADR 0124 amendment (call 8 and §9) and a rubrics brief line: controls Public, control assessments Internal.

**Done when:** an answer citing only a control can be approved and appears in the completed questionnaire on a DDQ with no NDA; adding the control's assessment as a source makes it held back as Internal; the assistant reports both correctly.