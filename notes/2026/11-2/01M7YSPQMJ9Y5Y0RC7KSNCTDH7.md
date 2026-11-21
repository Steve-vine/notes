---
id: 01M7YSPQMJ9Y5Y0RC7KSNCTDH7
created: 2026-11-21T10:16:20.370685Z
updated: 2026-11-21T10:17:06.260765Z
type: task
title: 'Assessment screen Overview: sections divided by lines and laid out as on the Control screen; "Security Assurance Plan" shown once; Ask Polaris to collect moves here'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2060
sprint: s9hexqn
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Raised by Steve while testing sprint 120 (2026-11-21). Part of one change, split across three tasks:
- **the Control screen is for viewing a control;**
- **the Assessment screen is where it's assessed and evidence is added.**

The other two tasks are the Control screen's actions going (COM-2061, which needs this one first) and flowcharts joining Managed Content (COM-2062). Related: COM-2056 (evidence listed once, in this Evidence section, with each piece's actions) and COM-2057 (the box's 2×2 buttons).

**Today.** On the Assessment screen's Overview, the sections below the control (Evidence, Gaps, Risks, Decisions, Framework mappings) are compact folding sections. They look different from the same things on the Control screen's tabs. Evidence also shows the heading "Security Assurance Plan" twice: once as the part's heading, and again as the label over the plan's rows.

**What people see after this**
- **A horizontal line between each section:** Evidence, Gaps, Risks, Decisions and Framework mappings.
- **Evidence looks the same as the Control screen's Evidence tab:**
  - the same four headings (Security Assurance Plan, Managed Content, Automated Collection, Manual Collection);
  - the same rows, pills and dates.
- **"Security Assurance Plan" appears once.**
- **The actions for adding evidence come here,** for people allowed to use them:
  - **Ask Polaris to collect this** (or "Ask Polaris for another check" when the control already has one) sits under Automated Collection, as it does today on the Control screen's Evidence tab. It's being taken off the Control screen (COM-2061), so it must exist here first.
  - Each piece's own actions (edit details, replace, archive, take off the control) come with COM-2056.
  - Add evidence, Raise gap, Add to SAP and Request exception stay in the assessment box (COM-2057).
- **Gaps and Risks look as they do on the Control screen's Gaps and Risks tabs:** the same table, columns and pills. They have no Raise gap or Request exception button of their own; those are in the box.
- **Decisions use the same style as Gaps and Risks.** It keeps **Add decision** for people who can record decisions, because linking a decision to a control now happens only here (COM-2061 takes it off the Control screen).
- **My call (Steve to overturn): the sections no longer fold.** Each shows open, under its heading and count, as on the Control screen. Decisions today starts folded.

**Implementation notes**
- `pages/AssessmentsQueuePage.tsx` (the focus panel's Overview). Today it renders:
  - `ControlEvidenceSection` (`assessments/`);
  - `ControlGapsCard` and `ControlRisksCard` with `frame="section" actions={false}`;
  - `LinkedDecisions frame="section" defaultOpen={false}`;
  - `FrameworksCard frame="section"`.
- The Control screen renders the cards with `frame="card"`, and its Evidence tab is `control/EvidenceTab.tsx`. Prefer **one component per section, used by both screens**, rather than restyling the section variant to look alike. That way the two screens can't drift apart again.
- **The double heading:** `ControlEvidenceSection` wraps `EvidenceOfOperationCard` (`bare`) in a "Security Assurance Plan" `Part`, and the card then labels its rows by `source_label`, which is also "Security Assurance Plan". Drop one.
- **Ask Polaris to collect** is in `collection/CollectionCard.tsx`, used today only by the Control screen's Evidence tab.
- Check the screen-conventions test, and update the Browser smoke journeys for the Assessment screen.
- Frontend only. Independent: no migration or API change. Build before COM-2061.

**Done when**
- On the Assessment screen's Overview, Evidence, Gaps, Risks, Decisions and Framework mappings are separated by lines, and each looks as it does on the Control screen.
- "Security Assurance Plan" appears once.
- Ask Polaris to collect this works from the Assessment screen's Automated Collection, and Add decision links a decision from its Decisions section, each for someone allowed to.
- Someone without those rights sees the same sections with no buttons.