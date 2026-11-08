---
id: 01M6TV12JM18EJRKV37B6ZXSJB
created: 2026-11-07T11:06:48.27676Z
updated: 2026-11-08T09:00:06.153422Z
type: task
title: 'Assessment: History moves out of the assessment box into its own tab, as on the control page'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1636
sprint: sp69tt3
comments:
- id: 01M6TZSJSPXVSZAFJD45RZTY7S
  author: Steve Vine
  at: 2026-11-07T12:30:05.622858Z
  text: |-
    Done: PR #1646, merged to main as 4504fef5.

    What changed: an open control on the Assessment screen now has two tabs, Overview (everything it showed before) and History, with a count. History is the control page's History tab, moved into one shared piece so the two always show the same thing: every save with its evidence, evidence changes, exceptions and check events, newest first.

    The assessment box no longer has a History section. The tab you pick stays while you step through controls, and goes back to Overview once you close the control. Saving adds the new entry straight away.

    Tested: no History in the box, the tab and its count, the entry shown, the tab kept while stepping, and back to Overview after closing and reopening.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Today a control's assessment history sits at the bottom of the right-hand assessment box on the Assessment screen. Steve (2026-11-07): remove it from the box and show it as a separate tab on the main screen, the same as the control page (Playbook ▸ control ▸ History tab).

**Wanted behaviour:**
- The main column of an open control gets tabs: **Overview** (everything it shows today: title, guidance, checks, the sections) and **History**, with a count as on the control page.
- History shows exactly what the control page's History tab shows for the current company: every saved assessment with its status, maturity and evidence, evidence added/replaced/archived, exceptions and check events, newest first, in the same layout.
- The assessment box no longer has a History section.
- The tab chosen stays chosen while stepping through the run (Up/Down, Save & next), so an assessor can read history control after control. Opening a control fresh starts on Overview.
- Saving an assessment adds the new entry to the History tab without a reload.

**Done when:** in E2E Test Company, opening an assessed control shows Overview and History tabs; History lists the same entries as that control's History tab in the Playbook; the assessment box has no History; saving a change adds an entry; Next keeps the History tab open on the next control.

**Implementation:** the control page's `History` component lives in `ControlDetailPage.tsx` (~line 513) with `mergeHistory` + the evidence/exception/check history hooks; lift it into a shared component and render it in `ControlFocus` (AssessmentsQueuePage). Remove the history block (~lines 615–660) and its now-unused hooks from `AssessmentPanel`. Follow the tab conventions in `brief/information-architecture.md` → Screen conventions. Touches the same files as the Evidence section and Raise gap tasks: merge one at a time.

**Independent:** no migration, no API change.