---
id: 01M5AAJZJYE5AJ9N8N7AG148JH
created: 2026-10-19T14:55:56.51005Z
updated: 2026-10-19T14:56:36.235041Z
type: task
title: The incident page is laid out in four areas — Identify, Respond, Review, Notify — with Incident Details first and the sections renamed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1117
sprint: serbigk
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19. Display only: nothing recorded changes. The new Eradicate section is its own task (COM-1118), which adds its card into the Respond area this task lays out.

## What people see

The incident page's cards are grouped under four headings, in this order, each heading shown above its cards:

**Identify**
1. **Incident Details** (was "Details")
2. Triage
3. **Impact** (was "Security impact")
4. **Scope** (was "Involved")

**Respond**
5. **Contain**
6. **Eradicate** (new: COM-1118)
7. **Recover**
8. Evidence

**Review**
9. **Governance** (was "Links")
10. Post-incident review

**Notify**
11. Notifications

### Incident Details

Now the first card. It reads, in this order:
- **Title**
- **Description**
- **Reported as**: what the reporter thought it was (was "Reporter thought:", shown inside Triage)
- **Affects**: what the reporter said it affects (was shown inside Triage)
- **Reported by**
- **Recorded by**

"Reported as" and "Affects" leave Triage. They show for every incident that has them, not only while it waits for triage. If either is empty, its line says so ("Not given").

### Response split up

The single **Response** card becomes separate **Contain** and **Recover** cards (and **Eradicate**, from COM-1118). Each keeps what it does today: its state, its facts, and its buttons (Mark contained / Mark recovered, Not applicable). The **In review** row is dropped. Starting the post-incident review still moves the incident to In review, and the status pill in the page header shows it.

## My calls (Steve to confirm)

- **Other category sections:** Service impact, Personal data breach and AI aren't in the list. They're impact assessments, so they sit in **Identify**, straight after Impact, and keep their names. With "Security impact" renamed to plain "Impact", an incident that is Availability + Security shows "Impact" and "Service impact" side by side.
- **Closure** goes at the end of **Review**, after the post-incident review, since closing is the last thing done.
- **Timeline** and **History** stay at the bottom, below the four areas, under no heading. **Key times** stays in the side column.
- A card a category doesn't bring still doesn't show. An area with no cards showing (e.g. Respond before triage) still shows its heading, with one dimmed line saying what comes there ("Contain, eradicate and recover appear once the incident is triaged").

## Notes (technical)

- `pages/IncidentDetailPage.tsx`: `MAIN_CARDS` becomes four labelled groups; the headings follow *Screen conventions* in `brief/information-architecture.md`.
- `incidents/IncidentStagesCard.tsx` splits into `IncidentContainCard` and `IncidentRecoverCard` (shared `StageRow`, modals unchanged). The forward-only rule stays: Recover's buttons wait for Contain (and Eradicate, once COM-1118 lands) to be settled.
- `IncidentDetailsCard` takes the title and `ReporterHints` (`incident.reported_kind`, `incident.reported_affects`); remove them from `IncidentTriageCard`.
- `labels.ts` `INCIDENT_SECTION_LABELS.security` → "Impact". Panel titles: Involved → Scope, Links → Governance. Check that the incident export/report PDF and the assistant's wording don't still name the old sections; if they do, rename those too so screen and report agree.
- Deep links that scroll to a card (`useScrollToCard`, ids like `#triage`, `#review`) keep working; Actions links to them.
- Update the page tests that find cards by title.

**Done when:** an incident on staging shows the four headed areas in the order above, Incident Details first with its six lines, separate Contain and Recover cards, and no "In review" stage row.