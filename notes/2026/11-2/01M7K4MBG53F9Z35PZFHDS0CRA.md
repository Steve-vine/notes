---
id: 01M7K4MBG53F9Z35PZFHDS0CRA
created: 2026-11-16T21:36:23.557092Z
updated: 2026-11-16T21:36:23.557092Z
type: task
title: 'Coverage belongs to the control, not the check: fully, partly (and what still needs a person) or manual only, confirmed by a person'
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1880
---
From Steve's testing of round 2 (staging 43d03f09). Steve: "'Fully or Partly' and 'What still needs a person' … shouldn't be in the Check itself as it depends on the control remaining static."

**The problem.** Each collected check carries its own "covers fully / partly" and "what still needs a person". But coverage is about the control: what the control asks for, and all the evidence it has together.
- If the control's wording changes, every check on it still says "fully", and nothing asks anyone to look again.
- A control with several checks has several separate "partly" notes, and nothing says whether the checks cover the control between them.
- Moving a check to another control (COM-1875) would carry the wrong answer with it.

**Behaviour** (assumptions decided here, not by Steve)
- **One answer per control** (per company): **Fully**, **Partly** or **Manual only**.
  - With **Partly**, the control also says **what still needs a person**.
  - With **Manual only**, it says why. This takes over the existing "accepted as manual only" mark, so there's one answer, not two.
  - A control nobody has looked at reads **Not yet looked at**, as Coverage does today.
- **Where.** The answer is shown and edited on the control's Evidence tab, by whoever can record assessments. The Coverage screen (Evidence Collection ▸ Coverage) reads from it and keeps its filters and its "doing" column as they are.
- **Polaris suggests, a person decides.** When Polaris designs or re-creates a check, it suggests the control's coverage and what still needs a person. The person approving sees the suggestion at Review and accepts or edits it. Polaris never sets a control's coverage directly.
- **"To confirm".** A control's answer is marked **to confirm** when:
  - the control's wording changes;
  - a check is added to it;
  - a check is moved off it (COM-1875);
  - a check is deleted (COM-1868) or replaced;
  - a check is switched off.
  The control keeps showing its last answer with "to confirm" beside it, on its Evidence tab and on Coverage, until a person confirms it or changes it. Coverage can be filtered to "to confirm".
- **Recorded.** There's an Activity line on the control for each change and each confirmation.
- **The check page.** The "Covers it fully / partly" badge comes off the check's card and the check's Details. Details reads "Evidences: CHM.2", linking to the control's Evidence tab, where coverage is.
- **Carrying over today's data**, per company and control:
  - any check that says fully → **Fully**;
  - otherwise, any check that says partly → **Partly**, with the checks' "what still needs a person" notes combined (each prefixed with its CHK ID);
  - a manual-only mark → **Manual only**, with its why.
  Any control with more than one check, or with a check and a manual mark, is marked **to confirm**.

**Done when**
- The behaviour above works on staging. Every control in Test Company shows the same coverage as before the change, apart from the "to confirm" marks.
- Polaris's collection tools and instructions are updated:
  - checks no longer take coverage;
  - controls' coverage is suggested at Review;
  - the explanations of coverage read it from the control.
- An ADR 0142 amendment records that coverage belongs to the control, and that it is marked "to confirm" when the control or its checks change.
- Tests cover:
  - carrying over the data (one check, several checks, a manual mark);
  - each event that marks a control "to confirm";
  - confirming and editing the answer;
  - accepting Polaris's suggestion at Review;
  - the Coverage screen and its filter.

**Where** (for the builder): models/collected_check.py (`covers`, `partly`, `ControlCollectionMark`), core/collection/coverage.py, api/v1/collected_checks.py, api/v1/collection_overview.py, core/collection/polaris_design.py and polaris_revalidate.py, assistant/tools/posture_collection.py, frontend checks/CoverageTab.tsx, checks/coverage.ts, control/EvidenceTab.tsx, collection/CollectionCard.tsx, checks/NoRuleCheckPage.tsx. This needs a migration: move the data and add the "to confirm" mark. The old columns are dropped in a later task, once nothing reads them.

COM-1875 (moving a check's control) builds on this one.