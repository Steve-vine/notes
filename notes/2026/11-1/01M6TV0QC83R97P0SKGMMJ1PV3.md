---
id: 01M6TV0QC83R97P0SKGMMJ1PV3
created: 2026-11-07T11:06:36.808663Z
updated: 2026-11-07T11:11:34.217018Z
type: task
title: 'Assessment: one Evidence section listing all of a control''s evidence'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1635
sprint: sp69tt3
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Today a control's evidence on the Assessment screen is spread around: an **Evidence of operation** box in the main column (SAP activities, incidents, attestations, data requests), and in the right-hand assessment box the evidence picker, uploaded files and a **Linked from elsewhere** list. Steve (2026-11-07): one **Evidence** section in the main column, the same kind of folding section as Gaps, Risks etc., listing links to all the evidence: content, SAP, automated and manually linked.

**Wanted behaviour:**
- A new **Evidence** section with a count, alongside Gaps, Risks, Linked content, Decisions and Framework mappings, in the same style. It's information only; nothing in it changes the assessment.
- It lists, each as a link to where it lives and grouped by where it came from:
  - **Content**: the policies, procedures and runbooks that cover the control
  - **Schedule (SAP)**: activities that prove it operates, last done / next due / overdue, plus incidents, attestations and data requests as the Evidence of operation box shows them today
  - **Collected**: captures Compass collects on a schedule (collected evidence, ADR 0142)
  - **Manually linked**: Evidence register items linked on the card, files uploaded to the assessment, and evidence linked to the control from elsewhere (audits, requests)
- Each row shows enough to judge it at a glance: name, date, and whether it is out of date or archived (as the register says).
- The separate **Evidence of operation** box is removed from the main column. Its "Add to the plan" button moves into the assessment box (COM-1638).
- The **Linked from elsewhere** list is removed from the right-hand box. The box keeps what changes the assessment: picking evidence, uploading, replacing and archiving a file.
- A source the reader can't see isn't listed, as today.
- Assumption (Steve to correct): the existing **Linked content** section stays as it is; the same content also appears in Evidence.

**Done when:** in E2E Test Company, on a control with linked content, a SAP activity, a collected capture and a manually linked register item, the Evidence section lists all four under their headings with working links and the right count; the Evidence of operation box and Linked from elsewhere are gone; uploading a file in the box makes it appear in the section.

**Implementation:** reuse what each source already reads: `EvidenceOfOperationCard` (evidence/), `LinkedEvidenceList` (audit/), `EvidenceFiles`/`EvidenceLinks` in `AssessmentPanel`, `LinkedContentCard`, and the collected-evidence captures (core/collection, api/v1/collection_*). Render it in `ControlFocus` (AssessmentsQueuePage) inside the sectioned `Stack` with `frame="section"`. Check whether the Playbook control page's Evidence of operation should change too: it's not asked for, so leave it unless they share one component, and say so in the PR. If one combined read is clearly better than five calls, it can be an API addition, and then the task joins the chain. Touches the same files as the History tab and actions tasks: merge one at a time.

**Independent** unless it adds an API read (then on the chain).