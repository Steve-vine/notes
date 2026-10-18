---
id: 01M572NQWJ24KHV2GW51R6SJRJ
created: 2026-10-18T08:39:55.026168Z
updated: 2026-10-18T08:39:55.026168Z
type: task
title: 'ADR: the Incident Register — a company''s record of every incident that matters, each with categories from Rubrics, a triage decision, a timeline, its notifications and what was learned, frozen once closed'
assignee: steve
label: brief
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1063
---
Sprint 76, Incidents - Register. Scoped with Steve on 2026-10-18. This record is the first task, and the rest wait for it.

## What the Incident Register is

A new module, **Incidents**, in the Modules section of the menu. It is each company's record of the incidents an auditor asks about under **SOC 2, HIPAA, ISO 27001 and ISO 42001**:

- **major outages** (P1/P2) affecting delivery of services;
- **security incidents**: a confirmed or reasonably suspected compromise of confidentiality, integrity or availability;
- **personal data breaches**: every one, at any severity;
- **AI incidents**, as defined in the ISO 42001 scope.

It is **governance-grade, not operational** (roadmap PRM-12). ISE runs the live response; Compass records what happened, what was decided, who was told and what was learned. An incident can carry an ISE reference (IN-NNNN).

## How it meets the frameworks

The library's Incident Management controls (IMA.1–19, plus AIG.16, PDH.16, SEA.6, VEM.13, INS.18) already map these requirements; the register is what makes them operate:

| Requirement | Met by |
|---|---|
| SOC 2 CC7.3 evaluate events · ISO A.5.25 · HIPAA 164.308(a)(6)(i) | Triage: incident, not an incident (with reason) or duplicate, kept either way |
| SOC 2 CC7.4 respond · ISO A.5.26 · HIPAA 164.308(a)(6)(ii) | Response stages and the timeline |
| SOC 2 CC7.5 recover | Recovery stage (authorised, not assumed), post-incident review |
| ISO A.6.8 event reporting · 42001 A.3.3 reporting concerns | Any employee reports from the User Portal |
| ISO A.5.27 learning · 42001 10.2 corrective action | Post-incident review raises gaps and risks, tracked to closure |
| ISO A.5.28 evidence | Evidence log and uploads |
| HIPAA 164.402 four-factor assessment | Personal data breach assessment |
| HIPAA 164.404–410 · UK GDPR Art 33/34 · 42001 A.8.3, A.8.4 | Notification obligations with deadlines, each decided |
| HIPAA 164.414(b) burden of proof · UK GDPR Art 33(5) breach record | Frozen record; nothing confirmed is ever deleted; yearly HIPAA log |

## What Steve decided (2026-10-18)

- **Categories are defined in Rubrics** and an incident holds **one or more** (e.g. Availability + Privacy).
- **Breach rules ship as UK GDPR + HIPAA** notification obligations, editable in Rubrics, plus a customer-contract placeholder.
- **Visibility:** everyone with incident access sees the register; a handler can mark an incident **restricted** (e.g. an insider case) so only named people see its contents.
- **Any employee reports from the User Portal, named.** They see their own reports and the status, not the internal working.
- **Severity is P1–P4**, wording editable in Rubrics.

## What the record has to settle (Claude's calls, not confirmed by Steve)

- **One company per incident**, like Vendors, Inventory and SAP. A shared-platform outage is recorded against each company it hit, and the incidents are linked as related.
- **References are `INC-12`**, one sequence across all companies like every other reference (G-, R-, AST-, SAP-).
- **Rubrics are organisation-wide**, like every other rubric. Categories are retired, never deleted, once used.
- **Each category adds a section to the incident:** Availability brings the services affected and the outage window; Security brings the C/I/A impact and suspected or confirmed; Privacy brings the breach assessment; AI brings the AI system and what went wrong. A new category picks which sections it brings.
- **Statuses:** Reported → Investigating → Contained → Recovered → In review → Closed. Triage can instead close it as **Not an incident** (reason) or **Duplicate of INC-NN**.
- **Nothing is deleted.** A report made in error is triaged as Not an incident, with a reason, because the decision is itself audit evidence.
- **The timeline is append-only.** A correction is a new entry pointing at the old one.
- **A post-incident review is required** for P1 and P2, for every Privacy incident and for every AI incident, due 14 days after recovery. Both are rubric settings.
- **Closing needs a checklist:** triage done, every triggered notification decided, the review recorded where required. Once closed the incident is frozen. A correction (with reason) or a reopen (with reason) is kept in its history.
- **A new report emails the handlers at once**, not in the hourly digest, because a 72-hour clock may be running. Notification deadlines also come up in Actions and the digest.
- **Restricted incidents still show in the register as a row**: reference, category, severity and dates, contents hidden. The register stays complete for an auditor's population, and nobody's case is exposed.
- **Inventory gains an "AI system" mark** on technology assets, so an AI incident can name the system. Nothing marks one today.
- **Permissions:** `incidents.view`, `incidents.handle` (record, triage, work and close any incident they can see) and `incidents.manage_restricted`. Built-in Admin only; the starter roles stay frozen (as with SAP, ADR 0115 §3).
- **The assistant can do what the screen does**, except upload or download files (ADR 0109). It sees restricted incidents only when the person can.

## Notes (technical)

- Write `decisions/0116-the-incident-register.md` unless another number has landed. Check every branch, not just main.
- Rubrics: org-wide, `data_type`'s retire-not-delete pattern (status + position, 409 when in use), with revision tables like the other rubrics.
- Reuse the existing patterns: the `nextval` reference sequence; `before_flush` activity log; polymorphic attachments; `decision_links`; SAP's finding links (gap/risk); the actions-queue source (ADR 0055); the Evidence of operation `SOURCES` registry (ADR 0115); `POST /portal/...` for reporting, which must be added to the portal write-routes allowlist test.
- Most tasks add a migration, so the stack is serial. Build in the order below; each task's blockers are set.

## Tasks (build order)

Numbers are filled in once the tasks exist.

**Done when:** the ADR is merged and the tasks below match it.