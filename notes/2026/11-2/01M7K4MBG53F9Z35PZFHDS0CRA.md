---
id: 01M7K4MBG53F9Z35PZFHDS0CRA
created: 2026-11-16T21:36:23.557092Z
updated: 2026-11-17T10:36:40.306151Z
type: task
title: 'Coverage belongs to the control, not the check: fully, partly (and what still needs a person) or manual only, confirmed by a person'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1880
sprint: s7nqsy0
comments:
- id: 01M7KHH4AQPF9JQ4DCJNNXCE7F
  author: Steve Vine
  at: 2026-11-17T01:21:49.399035Z
  text: |-
    Done — PR #1873, merged d9052288.
    Coverage now belongs to the control, not the check. On a control's Evidence tab, Automated Collection shows its Coverage — Fully, Partly (with what still needs a person) or Manual only (with why) — who said it and when, with Change, and Confirm when it's marked To confirm. The old "Mark as manual only" button and the "covers it fully / partly" badge on each check are gone; a check's Details reads "Evidences: CHM.2", linking to the control.
    A control is marked To confirm (saying what changed, e.g. "CHC-4 added") when its wording changes, a check is added, replaced, switched off (one at a time or in a batch) or deleted, or a built-in check is switched off. Coverage (Evidence Collection ▸ Coverage) shows a To confirm badge, a "Coverage to confirm" card and filter. At Review, a proposed check shows Polaris's suggestion for the control's coverage; the approver accepts or changes it, or leaves the control's coverage as it is, marked to confirm. Each change and confirmation is a line on the control's History tab.
    Assumptions: built-in checks no longer decide coverage on their own — existing companies were carried over, but a new company starts with every control "Not yet looked at". Switching a check back on doesn't mark to confirm.
    To check on staging: every Test Company control should read as before apart from To confirm marks (controls with several checks, or a check plus a Manual only mark, start To confirm). Try Change/Confirm on a control, and approve a proposal with and without the coverage tick.
- id: 01M7MH92ZJWGAYBT2N1FAYDD1T
  author: Steve Vine
  at: 2026-11-17T10:36:40.305949Z
  text: |-
    Pre-UAT on staging 44d15b9a — Failed (one defect: coverage lines don't show on History for a control that hasn't been assessed)
    - One answer per control, shown and changed on the Evidence tab: Passed. As E2E Admin A in E2E Test Company, on IDM.13 (two built-in checks, Partly, TO CONFIRM "Carried over from its checks… it has several checks") I clicked Confirm. The mark went at once, and it now reads "Said by E2E Admin A on 17 Nov 2026". Change offers Fully / Partly / Manual only. Manual only asks "Why it needs a person". I set Manual only, Coverage then showed IDM.13 as MANUAL ONLY, and I put it back to Partly with the original words. On ACC.13 I set Fully and then back to Partly with its original text.
    - Who can change it: Passed. E2E Assessor sees Confirm and Change. E2E Viewer sees the answer and TO CONFIRM with no buttons.
    - Carried over: Passed, looking only. In Test Company, CHM.2 shows Partly with each check's note prefixed CHC-24 / CHC-25 / CHC-26, marked To confirm ("it has several checks"); SOD.9 is the same with CHC-1…CHC-4. Test Company totals are 1 fully · 14 partly · 0 manual only · 404 not yet looked at, with 3 to confirm (CHM.2, IDM.13, SOD.9). I can't compare these with before the change, because I have no baseline.
    - To confirm marks: Passed for the events I could cause or see. A check moved off (COM-1875) gave "CHC-2 moved to ACC.12". Built-in checks switched off gave "CHB-5 switched off" on IDM.2 and "CHB-12 switched off" on IDM.18. Coverage has the "Coverage to confirm" card and a To confirm filter (?confirm=yes) listing exactly those controls. I didn't change a control's wording (Playbook is shared) or add a check.
    - Review shows Polaris's suggestion: Passed (seen, not approved). On CHC-1 (new) and CHC-3 (replaces CHC-2) it reads "Coverage of ACC.13: Polaris suggests Partly. Still needs a person: …", with "Leave ACC.13's coverage as it is, marked to confirm" and Fully / Partly / Manual only. Approving with and without the tick: Couldn't check. Approving would make a live check read the real Microsoft 365 account, so that one is for Steve.
    - Check page: Passed. CHC-2's Details reads "Evidences: ACC.13", and no covers-fully/partly badge is on the check.
    - Polaris: Passed over MCP. posture_collection_coverage reads coverage from the control, with "to_confirm": "CHB-12 switched off". posture_change_collected_check has no coverage setting.
    - Recorded (Activity / History): Failed on screen for unassessed controls. The lines are recorded: through the API, IDM.13 has "E2E Admin A confirmed IDM.13's coverage: Partly", "…set IDM.13's coverage to Manual only: …" and "…set … to Partly: …". IDM.13 isn't assessed, though, and its History tab shows only "History 0 · Not assessed yet." On ACC.13, which is assessed, the History tab does show "E2E Admin A set ACC.13's coverage to Fully" and the rest. Most controls aren't assessed, so most coverage changes are invisible on screen. Screenshot: IDM.13-history.png.
    - ADR 0142 amendment: Passed. "Amendment (2026-11-17, COM-1880): coverage belongs to the control" is on main.
    Observation: Polaris's suggestion text ends ".." ("…are not connected.. Coverage is the control's…").
    Screenshots: ~/compass-uat/s7nqsy0/COM-1880/
assignee: steve
priority: medium
task_status: review
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