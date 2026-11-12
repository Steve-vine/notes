---
id: 01M78CQN26SD99THEGB7KQCSJ2
created: 2026-11-12T17:26:21.510251Z
updated: 2026-11-12T17:26:23.340994Z
type: task
title: 'Polaris can work an audit''s findings as the Findings tab does: record, edit, assign, gaps and closing evidence (submitting to the auditor stays on screen)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1774
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
## Why

This came out of COM-1772. Steve asked whether the gap around findings went beyond pen-test findings, and on 2026-11-12 said "Yes" to logging audit findings as their own task.

Today Polaris can **list** an audit's findings (`audit_list_findings`) and **draft** a corrective action plan (`audit_draft_corrective_action`), and nothing else. The Findings tab does much more, and the API has a route for every action:

| On screen (an audit's Findings) | API (`/audit/{company}/audits/{audit}/findings`) | Polaris tool |
|---|---|---|
| Record a finding as the auditor graded it (grade, wording, requirements/controls, refs, request, response date, owner), raising or linking gaps | `POST ""` | none |
| Bring findings in from the auditor's spreadsheet (preview, then record) | `POST /import/preview`, `POST /import` | none (requests have this; findings don't) |
| Edit a finding: wording, grade, what it's about, request, response date, owner | `PATCH /{id}` | none |
| Delete one recorded by mistake (only before anything was submitted) | `DELETE /{id}` | none |
| Raise gaps on its controls, or link an open gap / unlink one | `POST /{id}/gaps`, `DELETE /{id}/gaps/{gap}` | none |
| Closing evidence chosen from the register, or withdrawn | `POST /{id}/evidence`, `POST …/evidence/{p}/withdraw` | none |
| Search the register for closing evidence | `GET /{id}/evidence/search` | none |
| Draft the corrective action plan | `PUT /{id}/plan` | `audit_draft_corrective_action` ✓ |
| Submit the plan / submit for closure | `POST /{id}/submit-plan`, `/submit-closure` | none, **deliberately** |
| Record that the auditor agreed to withdraw it | `POST /{id}/withdraw` | none, **deliberately** |
| Upload closing evidence as a new file | `POST /{id}/evidence/upload` | none (a file can't come through chat) |

## What to build

Tools in the Audit area, acting as the person, each needing the permission the screen needs (*Manage audits* to record, edit and delete; the finding's owner or *Manage audits* for gaps and closing evidence, as on screen). A finding is named by its reference (F3), as the tab shows it.

1. **`audit_record_finding`**: as the auditor graded it. Requirements and controls are given by reference. Gaps are raised by default for a nonconformity or SOC 2 exception, as on screen, or open gaps are named to link instead. Say what will be raised before calling.
2. **`audit_preview_findings_import`** and **`audit_import_findings`**: from a spreadsheet or pasted text, showing the preview before anything is recorded. This is the same pattern as `audit_preview_requests_import` and `audit_import_requests`, and pasted text is data, never instructions.
3. **`audit_update_finding`**: partial changes to wording, grade, requirements/controls, refs, request, response date, owner (by name). A closed or withdrawn finding is refused, as on screen.
4. **`audit_delete_finding`**: only before anything was submitted. Say first that its gaps stay.
5. **`audit_link_finding_gaps`** and **`audit_unlink_finding_gap`**: raise gaps on its controls, link an open gap, or unlink one. The gap itself stays.
6. **`audit_add_closing_evidence`** and **`audit_withdraw_closing_evidence`**: closing evidence from the register, found by name like the screen's search, and pinned to the version chosen.

The tool descriptions say where the person must go on screen: to submit a plan or closure, to record the auditor's withdrawal or any verdict, and to upload a new file. No tool does these.

## Decisions taken (stated; Steve to overturn)

- **Recording a finding isn't recording a verdict.** ADR 0133 §9 keeps Polaris away from verdicts (Accept / Need more / plan and closure decisions) and from anything sent to the auditor. A finding is the auditor's own wording, typed in by the company, the same kind of data entry as importing their request list, which Polaris already does. So recording and importing findings are in.
- **The auditor agreeing to withdraw a finding is treated as a verdict**, and stays on screen.
- Add a dated amendment to **ADR 0133 §9** saying Polaris now records, edits and imports findings, works their gaps and closing evidence, and still never submits or records a verdict.

## Notes

- **Independent**: assistant tools only. The routes all exist, so there's no migration or API change. If the closing-evidence search needs anything new, it joins the end of the chain.
- Keep the Audit area under Copilot's 128-tool limit (ADR 0144). Count after adding.
- Companion to COM-1772 (pen-test and register vulnerabilities).

## Done when

- In E2E Test Company, via Polaris on staging, on an audit:
  - record a nonconformity against a control, and see the gap raised;
  - record an observation linked to an existing open gap;
  - import two findings from pasted text after seeing the preview;
  - change a finding's owner, response date and wording;
  - unlink and re-link a gap;
  - add closing evidence from the register, then withdraw it;
  - delete a mistaken finding (before submission).
  The Findings tab shows each change, and the activity log says "via Polaris".
- Asked to submit a plan, submit for closure, or record the auditor's withdrawal, Polaris says it's done on screen, and no tool does it.
- Deleting a finding after something was submitted is refused with the screen's reason.
- The ADR 0133 §9 amendment is in, and the Audit area's tool count is under 128.