---
id: 01M7YPERP6JYM2J3EV6YRXN6SD
created: 2026-11-21T09:19:33.574401Z
updated: 2026-11-22T08:13:22.308537Z
type: task
title: 'Assessment screen: the assessment box keeps only Add evidence; the evidence is listed once, in the page''s Evidence section'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2056
sprint: s9hexqn
comments:
- id: 01M7Z2385VKX9AVGW8849WV7YF
  author: Steve Vine
  at: 2026-11-21T12:42:59.131027Z
  text: |-
    Done — merged to main as PR #2054 (not yet on staging; goes out with the round-5 deploy).

    What changes for people
    - On the Assessment screen the assessment box keeps only Add evidence; it no longer lists evidence.
    - The page's Evidence section is the one place evidence is listed, and a piece added with the box's button appears there straight away.
    - Each piece under Manual Collection has its own actions there for people who record assessments: edit details, new version, archive, take off this control, and unlink a piece linked from elsewhere. Archived pieces fold away under "N archived". Viewers see no buttons.
    - The "Not assessed yet" hint now says the evidence is listed in the Evidence section once the assessment is saved.
    - An initiative's Assess drawer still lists evidence in its box (it has no Evidence section to point to).

    Calls: none beyond the task's.
    Checked: Vitest (box lists nothing but keeps Add evidence; each piece listed once with its actions; a viewer gets no buttons); Assessment panel and queue suites, type-check, lint and format all pass.
- id: 01M7Z4YS8PF114PXXN84W89YV2
  author: Steve Vine
  at: 2026-11-21T13:32:58.517889Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps: As E2E Admin A, opened RIM.9 on the Assessment screen. From Evidence ▸ Manual Collection, on EVD-88: Edit details, New version, then Archive (reason "Wrong file uploaded"). Took EVD-66 off. Read RIM.8's "Not assessed yet" hint. Opened Assess from initiative INI-5's row menu. Then checked as E2E Viewer.
    Seen:
    - The box holds only its four buttons and lists no evidence. Each piece appears once, under Manual Collection, with its actions in an end column.
    - Every action took effect at once, without a reload. "2 archived" folds away, showing the reason and the "Replaced by a newer version" line.
    - The hint reads "…is listed in the Evidence section once the assessment is saved."
    - The initiative's Assess drawer still lists the evidence, with its actions.
    - The Viewer sees the list with no buttons.
    Follow-up: at 1440 wide, the actions column sits off to the right of the table, so you have to scroll it sideways to reach the buttons. Logged as a fix-forward task.
    Screenshots: ~/compass-uat/s9hexqn/COM-2056/
assignee: steve
label:
- improvement
priority: medium
task_status: done
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