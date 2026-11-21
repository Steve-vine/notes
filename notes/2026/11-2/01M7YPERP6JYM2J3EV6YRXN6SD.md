---
id: 01M7YPERP6JYM2J3EV6YRXN6SD
created: 2026-11-21T09:19:33.574401Z
updated: 2026-11-21T10:46:35.703158Z
type: task
title: 'Assessment screen: the assessment box keeps only Add evidence; the evidence is listed once, in the page''s Evidence section'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2056
sprint: s9hexqn
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Raised by Steve while testing sprint 120 (2026-11-21).

**The problem.** On the Assessment screen, a control's evidence is listed twice:
- in the page's **Evidence** section (Security Assurance Plan, Managed Content, Automated Collection, Manual Collection);
- again in the assessment box on the right, under its Evidence heading: the files and web addresses added to the assessment.

**What people see after this**
- The assessment box's Evidence heading has just the **Add evidence** button, for people who can record assessments. It no longer lists any evidence.
- The page's Evidence section is the one place the evidence is listed. Something added with the button appears there at once, without a reload.
- **The actions on each piece move with the list.** Today the box is where a piece's details are edited, and where it is replaced, archived or taken off the control. The Evidence section only reads. Those actions must not be lost:
  - Each piece under Manual Collection in the Evidence section gets the same actions, for people allowed to use them.
  - Anyone else sees the list without them, as now.
  - The same goes for the archived evidence list, if the box shows one.
- **The "Not assessed yet" hint** under the button currently says the evidence "is listed here once the assessment is saved". Change it to point to the Evidence section.
- **My call (Steve to overturn): other screens keep their list.** This changes the Assessment screen only. The same box appears in an initiative's Assess drawer and in a control's evidence view. Those have no Evidence section beside them, so they keep listing evidence in the box.

**Implementation notes**
- The box is `AssessmentPanel` (`components/AssessmentPanel.tsx`). The Assessment screen (`pages/AssessmentsQueuePage.tsx`) already passes `linkedElsewhere={false}` to hide the "linked from elsewhere" list (COM-1635). Extend that so it also hides `EvidenceLinks` and `EvidenceFiles`: one prop meaning "the page lists the evidence", rather than a second flag.
- `assessments/ControlEvidenceSection.tsx` says in its header that it only reads, and that adding, replacing and archiving stay in the box. Update the header along with the behaviour.
- Probably frontend only. Independent: no migration or API change.

**Done when**
- On the Assessment screen, the assessment box shows Add evidence and no evidence list, and each piece appears once, in the Evidence section.
- A piece's details can still be edited, and it can still be replaced, archived and taken off the control, from the Evidence section by someone allowed to.
- Evidence added with the button appears in the Evidence section at once.
- The Assess drawer on an initiative still lists evidence in its box.