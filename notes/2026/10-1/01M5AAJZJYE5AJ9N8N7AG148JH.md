---
id: 01M5AAJZJYE5AJ9N8N7AG148JH
created: 2026-10-19T14:55:56.51005Z
updated: 2026-10-19T15:25:49.768216Z
type: task
title: The incident page is laid out in four areas — Identify, Respond, Review, Notify — with Incident Details first, one Impact section, and Closure in the side column
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1117
sprint: serbigk
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19 (three rounds). Display only: nothing recorded changes. The new Eradicate section is its own task (COM-1118), which adds its card into the Respond area this task lays out.

## What people see

The incident page's main column is grouped under four headings, in this order, each heading shown above its cards:

**Identify**
1. **Incident Details** (was "Details")
2. Triage
3. **Impact** (was "Involved", now also holding the category impact sections)

**Respond**
4. **Contain**
5. **Eradicate** (new: COM-1118)
6. **Recover**
7. Evidence

**Review**
8. **Governance** (was "Links")
9. Post-incident review

**Notify**
10. Notifications

**Side column:** **Closure** replaces Key times, in the same place, and stays in view as the page scrolls, as Key times does today. **Key times is removed.**

### Incident Details

Now the first card. It reads, in this order:
- **Title**
- **Description**
- **Reported as**: what the reporter thought it was (was "Reporter thought:", shown inside Triage)
- **Affects**: what the reporter said it affects (was shown inside Triage)
- **Reported by**
- **Recorded by**
- **Occurred**, **Detected**, **Company aware** (moved from Key times; see My calls)

"Reported as" and "Affects" leave Triage. They show for every incident that has them, not only while it waits for triage. If either is empty, its line says so ("Not given").

### Impact

One card in place of Involved and the four category sections. It reads:
- **Technology assets**
- **Data assets**
- **Vendors**
- **People affected**
- **Impact Detail**: the impact specific to the incident's categories, each as a sub-section with its own Edit button, shown only when a category brings it:
  - **Security impact** (confidentiality / integrity / availability, confirmed or suspected, attack or cause)
  - **Service impact** (services affected, outage times)
  - **Personal data breach** (the UK GDPR and HIPAA assessment and conclusion)
  - **AI impact** (was "AI section")

Each sub-section keeps everything it records and edits today; only where it sits changes. If no category brings any of them, Impact Detail doesn't show. The breach section is long, so it can be collapsed. The other sub-sections open expanded.

### Response split up

The single **Response** card becomes separate **Contain** and **Recover** cards (and **Eradicate**, from COM-1118). Each keeps what it does today: its state, its facts, its time, and its buttons (Mark contained / Mark recovered, Not applicable). The **In review** row is dropped. Starting the post-incident review still moves the incident to In review, and the status pill in the page header shows it.

### Closure in the side column

- **At the top of Closure: the incident's current status**, e.g. Reported, Investigating, Contained, Recovered, In review, Closed, Not an incident. It uses the same pill as the page header, and changes as the incident moves on.
- Below it, the Closure card moves unchanged: the checklist (each item ticked, or what's missing), **Close incident**, and once closed who closed it, when and the summary, with Correct and Reopen.
- It shows from the start, so the status and the checklist tell a handler where the incident stands and what's still to do as they work.

## My calls (Steve to confirm)

- **Key times goes, and its facts move:**
  - **Occurred, Detected and Company aware** move into Incident Details. Company aware starts the ICO's 72-hour clock, so it must stay on the page.
  - Each stage's time already shows on its own card: Triage, Contain, Eradicate and Recover, plus Closed on Closure.
  - The **durations** (time to detect, triage, contain and recover) leave the page. They stay in the incident report, the register export and the Overview's averages.
- **Security impact** sits in Impact Detail with the other three, since it too only shows for its category. This replaces the earlier rename of it to plain "Impact", and the "Scope" name is no longer used.
- **Timeline** and **History** stay at the bottom of the main column, below the four areas, under no heading.
- An area with no cards showing (e.g. Respond before triage) still shows its heading, with one dimmed line saying what comes there ("Contain, eradicate and recover appear once the incident is triaged").

## Notes (technical)

- `pages/IncidentDetailPage.tsx`: `MAIN_CARDS` becomes four labelled groups; `SIDE_CARDS` = `[IncidentClosureCard]`. Headings follow *Screen conventions* in `brief/information-architecture.md`. Check the Closure card's modals and its corrections list fit the side column's width; on narrow screens the side column stacks as it does today.
- `IncidentClosureCard`: a status line at the top using the page header's status pill component and labels (one source for the status wording). Today the card may render nothing for some states, e.g. before triage or when triaged out; it now always renders, showing at least the status.
- Delete `IncidentKeyTimesCard.tsx` (and its tests); add the three times to `IncidentDetailsCard` with the existing "Not known" wording.
- `IncidentInvolvedCard` → the Impact card. `IncidentSecurityImpactCard`, `IncidentServiceImpactCard`, `IncidentPrivacyBreachCard` and `IncidentAiCard` render inside it as sub-sections (`SectionCard` becomes a sub-section rather than a Panel; `INCIDENT_SECTION_LABELS.ai` → "AI impact"). Their modals are unchanged.
- `incidents/IncidentStagesCard.tsx` splits into `IncidentContainCard` and `IncidentRecoverCard` (shared `StageRow`, modals unchanged). The forward-only rule stays: Recover's buttons wait for Contain (and Eradicate, once COM-1118 lands) to be settled.
- `IncidentDetailsCard` takes the title and `ReporterHints` (`incident.reported_kind`, `incident.reported_affects`); remove them from `IncidentTriageCard`.
- Panel title Links → Governance. Check that the incident report PDF and the assistant's wording don't still name the old sections ("Involved", "Links", "AI section"); if they do, rename those too so screen and report agree.
- Deep links that scroll to a card (`useScrollToCard`, ids like `#triage`, `#review`, and any section anchors) keep working; Actions links to them. A link to a category section scrolls to its sub-section inside Impact.
- Update the page tests that find cards by title.

**Done when:** an incident on staging shows the four headed areas in the order above; Incident Details first with its lines; one Impact card listing assets, vendors, people affected and the Impact Detail its categories bring; separate Contain and Recover cards with no "In review" row; Closure in the side column with the current status at its top; and no Key times card.