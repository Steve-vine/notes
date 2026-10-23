---
id: 01M5G5QXBK6N7VHRQRFPX1JFJ0
created: 2026-10-21T21:26:41.779798Z
updated: 2026-10-23T03:12:52.534913Z
type: task
title: An approved assessment is evidence — it appears in Audit ▸ Evidence, as Evidence of operation on the risk controls, and it completes the plan's yearly "Risk assessment review"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1230
sprint: s33gwqy
blocked_by:
- 01M5G5QNS286SYT321T2Q5TX1R
comments:
- id: 01M5KBYG4402P8H5KV5X0FQHPN
  author: Steve Vine
  at: 2026-10-23T03:12:52.356094Z
  text: |-
    Done — merged in PR #1255 (migration 0570). Not yet on staging.

    - Audit ▸ Evidence lists every approved assessment's PDF, from "Risk Assessments RA-7". It is a Report or export covering the approval day, and never goes out of date. It supports RIM.2, RIM.3, RIM.4 and RIM.6, plus INA.4 when the assessment was started for a significant change. An approved DPIA's PDF supports PDH.12. The source filter has a new "Risk Assessments" option.
    - Evidence of operation:
      - RIM.2, RIM.3, RIM.4 and RIM.6 show how many risk assessments were approved in the last 12 months, how many are being worked, and the latest (e.g. "RA-7 · 23 threats · approved 3 Mar 2026");
      - RIM.3 warns when the current one is past its due date;
      - INA.4 shows the assessments started for a significant change.
    - On the plan, the yearly "Risk assessment review" has a Risk assessment card. "Mark done" offers "Done by a risk assessment": pick one of the company's approved assessments, and its PDF counts as the evidence, so nothing needs uploading. The activity then reads "Done by RA-7".
    - An open review activity can "Start a risk assessment", and keeps the link. The assessment's Details show its plan activity.

    My calls:
    - A replaced (superseded) assessment's PDF isn't archived. Each one records an assessment that really happened, the way incidents are treated.
    - An hourly background job makes any approved PDF the worker missed, so the evidence item exists even if nobody downloads it.
    - "Done by a risk assessment" is offered on plan activities linked to the risk controls (RIM.2/3/4/6), rather than tied to the plan template.
    - It needed a small migration (a link from the plan activity to the assessment), although the task was marked API-only.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 83, Risk Assessments (ADR in COM-1219). Needs sprint 82's Evidence register (COM-1205) to have landed.

**Chain:** on the chain — API

## What people see

- **Audit ▸ Evidence:** every approved assessment's PDF is a piece of evidence — type *Report or export*, period covered = the assessment's date, from "Risk Assessments RA-7". As finished work it never goes out of date; a newer approved one of the same kind is what keeps the control current.
- **Evidence of operation** on a control's assessment, the same way the plan, incidents and privacy requests show theirs:
  - **RIM.2, RIM.3, RIM.4, RIM.6** — each approved risk assessment ("RA-7 approved 3 Mar 2026 · 23 threats"), and RIM.3 shows overdue when the latest is past its due date;
  - **INA.4** — assessments started for a significant change;
  - (DPIA, PCI and AI kinds add theirs in their own tasks: PDH.12, AIG.5/AIG.6, the PCI requirement's controls.)
- **The SAP:** the standard plan's yearly **Risk assessment review** activity can be completed by picking an approved assessment ("Done by RA-7"), and a plan activity can start an assessment with the link kept.

## Notes (technical)

- Register a source in `core/evidence_of_operation.py` and the evidence registry from COM-1205.
- Look controls up by `CoreControl.key`.

**Done when:** approving RA-1 makes its PDF appear in Audit ▸ Evidence and on RIM.2's Evidence of operation; the plan's risk assessment activity can be marked done by RA-1.