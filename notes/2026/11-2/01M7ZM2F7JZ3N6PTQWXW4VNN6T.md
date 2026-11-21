---
id: 01M7ZM2F7JZ3N6PTQWXW4VNN6T
created: 2026-11-21T17:57:07.954058Z
updated: 2026-11-21T17:57:07.954058Z
type: task
title: Reviewing a register — a review cycle, Mark as reviewed with a comment, the review filed as evidence on its controls and completing a due SAP entry; reminder dates on entries reach the person responsible
priority: high
label: feature
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2083
---
Sprint "Registers" (ADR in COM-2076). Builds on COM-2079 (a register's controls), COM-2080 (evidence on registers) and COM-2082 (the PDF of a register as at a date). INS.5, INS.12 and IMA.3 each ask for "the last review record". This task makes it.

## What people see

**A review cycle**
- In a register's Settings: **Review every** N months (default 12). Off is allowed.
- The Registers list and the register's header show **Last reviewed** (date and who) and **Next review** (date). Next review turns amber within 30 days and red once overdue.

**Mark as reviewed**
- The owner, editors and administrators see **Mark as reviewed** on the register.
- It asks for an optional comment ("Checked against the ICO's 2026 guidance; added OBL-17, archived OBL-3") and shows what will happen. Confirming:
  1. Records the review: who, when and the comment. The register gains a **Reviews** tab listing every review, newest first.
  2. **Files the review as evidence:** the register as it stood at that moment, as a PDF (COM-2082's export), with type "Register review" and the comment as its description.
     - It's linked to each of the register's controls in each company where that control is applicable: the register's company for a per-company register, or every such company for a shared one. A register with no controls still records the review and files the PDF in the register's company, linked to nothing.
     - Its classification is the register's (see Settings below).
  3. **Completes a linked SAP entry that's due.** In Settings, the register can name its SAP entry (one per company), such as a yearly "Review the legal and regulatory register". If that entry is open and its due window has started, marking the register reviewed completes it with the review's evidence. If it isn't due yet, it's left alone and the confirmation says so.
- **A review is permanent.** Its comment can be corrected with a reason, and the original is kept in the activity log (the ADR 0149 pattern).
- **A per-company register is reviewed company by company.** A shared register is reviewed once for all.

**Reminders (Actions, ADR 0055)**
- **Register reviews:** "Review the Legal and regulatory obligations register — due 31 Mar" goes to the owner 30 days before the next review and stays until it's done. It turns overdue after the date.
- **Entry dates:** a Date field set to remind (COM-2077) puts "OBL-4 Data Protection Act 2018 · Review by 14 Jan" on the Actions queue of the entry's Responsible person, or the register's owner if there is none. It appears that many days before, and stays until the date is changed or the entry is archived.
- Both come in the daily mail like other Actions (derived mail, ADR 0055).

**Settings this adds**
- Review every N months.
- The register's SAP entry, per company.
- The **classification for review evidence** (Internal by default; a Restricted register defaults to Confidential).

## Implementation notes (technical)

- A register-review table: register, company (for per-company registers), who, when, comment, and the evidence ID or IDs.
- Filing evidence uses the ADR 0164 evidence model and the COM-2082 PDF renderer. Link the piece to controls through the existing control-evidence path, so it starts Unchecked and runs that control's workflows like any added evidence (ADR 0155).
- Completing the SAP entry uses the same path as completing it by hand with linked evidence, including its recurrence.
- Declare both reminder sources to the actions queue (ADR 0055). Register a label in core/task_labels.py for any new Celery task.

## Done when
- A register can be given a review cycle, and its list row and header show the last and next review, amber and red as it nears and passes.
- Mark as reviewed records the review with its comment, files a PDF of the register as evidence on its controls in each applicable company, and completes the register's SAP entry when that's due.
- Reminder dates on entries, and register reviews coming due, appear in the right person's Actions and the daily mail.

On the chain: migration and API.