---
id: 01M62A7VGG3GCGJCEMAFKHSMVX
created: 2026-10-28T22:31:38.256615Z
updated: 2026-10-28T22:33:43.88441Z
type: task
title: 'ADR: audit management — an audit is a record with its scope, the auditor''s request list answered from the Evidence register, findings graded by the auditor and worked as gaps, and a portal where invited auditors read, comment and accept but never change anything'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1425
sprint: swcbxt0
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Sprint 97, Audit Management (ADR 0133). Builds on:
- ADR 0122 (Audit ▸ Evidence, audit packs);
- ADR 0115 (SAP's Audit activity and its findings);
- ADR 0120 (Trust Centre sign-in by link and code, watermarking);
- ADR 0055 (Actions);
- ADR 0109 (Polaris).

Write `decisions/0133-audit-management.md`, and add Audit ▸ Audits and the auditor portal to `brief/information-architecture.md`.

## What's there already (unchanged)

- The Evidence register.
- Audit packs for a period.
- SAP's **Audit** activity (schedule, owner, evidence, outcome, linked gaps and risks, the auditor export).
- The Trust Centre's sign-in and watermarking.
- A note on the Compliance timeline.

## What the ADR decides

1. **An audit is a record**, at **Audit ▸ Audits**, per company. It has:
   - a **kind**: internal; external certification, surveillance or recertification; SOC 2 Type I or Type II; other external;
   - the **framework(s)** and level in scope, and a scope statement;
   - the **audit firm** (picked from the Vendor register or typed) and the auditors;
   - an internal **audit lead**;
   - dates: planned, fieldwork, stage 1 / stage 2, and a SOC 2 Type II **observation period**;
   - a status: Planned → Fieldwork → Reporting → Closed, or Cancelled;
   - its **outcome**.
   - A SAP Audit activity links to it both ways; the plan keeps the schedule and the reminders.
2. **The request list (PBC)** belongs to the audit. A request has:
   - the auditor's own reference and wording;
   - the requirement(s) or control(s) it's about;
   - an internal owner and a due date;
   - a status: Open → Provided → Accepted, or Need more → Provided again; or Withdrawn;
   - the **evidence provided**, linked from the Evidence register. Nothing is copied, and anything uploaded for a request is filed in the register.
   - Requests come in by hand or by **spreadsheet import**.
3. **Findings belong to the audit**, graded the auditor's way: major or minor nonconformity, observation, opportunity for improvement, or SOC 2 exception.
   - A nonconformity or exception **raises a gap** on the control(s) concerned, or links an existing one. An observation or improvement opportunity may.
   - Each finding carries a **corrective action plan** (correction, root cause, corrective action, owner, date) and its closing evidence.
   - A finding closes only when the auditor accepts it, in the portal or recorded by the audit lead. Closing its gap alone doesn't close the finding.
4. **The auditor portal** (Steve, 2026-10-28, option 2): auditors are invited to **one audit**, sign in with a link and an emailed code (as the Trust Centre), and have access until a date. They can:
   - **see** the audit, its requests, the evidence provided (watermarked downloads) and the findings with their responses;
   - **comment** on a request or a finding;
   - mark a request **Accepted** or **Need more**;
   - **accept** a finding's corrective action and its closure.

   They **never** add or change requests, findings or any Compass record, and see nothing outside their audit. Every view and download is logged.
5. **Internal audits** use the same record without the portal. The auditors are Compass users, named on the audit, who get the same accept and comment rights in Compass for that audit only. An internal audit shows as Evidence of operation on INA.2.
6. **Closing an audit** files the certificate and report in the Evidence register, optionally publishes the certificate to the Trust Centre, and produces a closing summary PDF. **Start the next one** carries the request list forward, for surveillance audits.

## Who can do what

| Permission | Allows |
|---|---|
| View audit (`audit.view`, existing) | See audits, requests, findings and portal activity |
| Manage audits (new) | Create and edit audits, import and manage requests and findings, invite, extend and revoke auditors, close an audit |
| Request owner (no permission needed) | Provide evidence for their own requests, using Manage evidence or the evidence's own module as today |

Built-in Admin only for the new permission; the starter roles stay frozen (ADR 0115 §3).

## My calls (for Steve to overturn)

- One audit can cover several frameworks, such as ISO 27001 plus 27701.
- Comments are internal by default. The person writing chooses **Shared with auditors**, and internal comments never reach the portal.
- An auditor's access ends 30 days after the audit's planned end by default.
- No NDA step for auditors, because engagement letters cover confidentiality. It can be switched on per audit if asked.
- The portal lives on the same external address as the Trust Centre, but is a separate area with its own on/off switch.
- Evidence provided to an auditor is frozen as provided. Replacing it in the register later doesn't change what the auditor saw; the new version is shown beside it.

## Notes (technical)

- Reuse the Trust Centre sign-in (`api/trust_centre/sign_in.py`, `TrustCentreVisitor` link tokens per ADR 0051, `rejection()`, code email). Prefer extracting the shared part over copying it.
- Watermark with `core/trust_centre_watermark.py`.
- Look up controls by key (COM-1062). The key for INA.2 is `INA.2`.

**Chain:** independent (docs only).

**Done when:** ADR 0133 is merged and Steve has read the calls above.