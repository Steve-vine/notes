---
id: 01M62AB9KWXSEJVKQKG17M97BS
created: 2026-10-28T22:33:31.004412Z
updated: 2026-10-30T08:01:13.279723Z
type: task
title: Closing an audit — record the outcome, file the certificate and report as evidence (and optionally publish the certificate to the Trust Centre), produce a closing summary PDF, and start the next audit from this one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1433
sprint: swcbxt0
blocked_by:
- 01M62AAXJGBWT4Z0ZV7WD510XC
comments:
- id: 01M649TF56F5E5YTDQ1B0RZ79X
  author: Steve Vine
  at: 2026-10-29T17:02:48.486577Z
  text: |-
    Done — PR #1450 (stacked on #1449). Migration 0739.

    What's there: Close audit from Reporting (the lead or Manage audits) — what's still open listed, a reason needed to close anyway; the outcome for the kind (certification, SOC 2, or words); the report (required for external audits) and the certificate with its valid-until, filed in Audit ▸ Evidence as "Certificate or audit report"; Publish the certificate to the Trust Centre (replacing and archiving the previous one there). The linked plan activity is marked Done with the outcome, the report as its evidence. A closing summary PDF is made in the house style and kept on the audit and in the register. Open findings stay open, workable and in Actions. Start the next one copies the frameworks, firm, auditors and requests (Open, no evidence) and carries open findings ("Carried from AUD-n"). A vendor that audited the company shows "Audited us: AUD-n" on its Overview.

    My calls, for you to overturn:
    1. Deviation: the next audit's dates are put a year on from this one's, to be changed, rather than left blank — an audit can't be recorded without planned dates, and surveillance audits are annual.
    2. A certification or recertification is followed by a surveillance audit; other kinds keep their kind.
    3. Copied requests keep their owners and internal notes, but not their due dates.
    4. The report and certificate are filed on the plan activity when there is one still to be marked done (so the plan's Done carries them), otherwise straight into the register. They aren't linked to controls.
    5. The Trust Centre certificate is named after the audit's frameworks ("ISO/IEC 27001 certificate") and replaces an earlier one with the same name; its badge scheme comes from the framework (27001, 27701, 42001, PCI, HITRUST, Cyber Essentials — "other" otherwise).
    6. The publish tick appears only once a certificate is chosen, and only for people who manage the Trust Centre's documents.
    7. A reason is needed if anything is open, even just a request.
    8. "Audited us" sits in the vendor's Engagements card (there's no Engagements tab).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 97, Audit Management (ADR 0133, COM-1425).

## What people see

- **Close audit** (audit lead or *Manage audits*), from Reporting:
  - **outcome**:
    - for certification audits: Recommended for certification / Recommended with conditions / Not recommended;
    - for SOC 2: Unqualified / Qualified / Adverse / Disclaimer;
    - for internal audits: free text;
  - the **report** (required for external audits) and, for certification, the **certificate** with its valid-until date. Both are filed in Audit ▸ Evidence as "Certificate or audit report", linked to the audit's frameworks;
  - **Publish the certificate to the Trust Centre** (ticked by default when the company has a Trust Centre). It replaces the previous certificate there, which is archived as ADR 0122 says.
- **Before closing**, Compass lists what's still open: requests not accepted, findings not closed. Closing anyway needs a reason, such as "Findings carried into the surveillance audit". Open findings stay open and stay in Actions after the audit closes.
- **Closing summary PDF** (house style): scope, dates, auditors, outcome, requests by status with how long each took, findings by grade with plan and closure dates, and what's still open. It's added to the audit and the Evidence register.
- **Start the next one** on a closed audit: a new audit with the same frameworks, firm and auditors. Its requests are copied as Open with no evidence, and its dates are left blank. Open findings are **linked**, not copied: they show on the new audit as "Carried from AUD-12".
- The audit's linked SAP activity is marked **Done** with the outcome and the report as its evidence, if it isn't already.
- **The vendor** (when the audit firm is a vendor) gets "Audited us: AUD-12" on its engagements tab. This is informational.

## Who can do what

- *Manage audits* or the audit lead closes and starts the next one.
- Publishing to the Trust Centre also needs the Trust Centre's document permission. Without it, the tick isn't offered.

## Notes (technical)

- Outcome enum per kind. Files go through the register's write path (ADR 0122 §4). Trust Centre publication goes through its document service, replacing and archiving.
- The PDF uses the house style (ADR 0110) and is generated in the worker.
- Completing SAP reuses SAP's complete path, with the same rules as completing by hand.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve closes an audit with one open finding (giving a reason), uploads a certificate that appears in the Evidence register and on the Trust Centre, downloads the closing PDF, and starts the next audit with the requests and the carried finding.