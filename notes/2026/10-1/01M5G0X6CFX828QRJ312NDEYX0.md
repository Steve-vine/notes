---
id: 01M5G0X6CFX828QRJ312NDEYX0
created: 2026-10-21T20:02:11.983979Z
updated: 2026-10-22T18:24:39.935179Z
type: task
title: Add evidence straight into the register, and link one piece of evidence to every control it proves — so one firewall review supports three controls without being uploaded three times
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1209
sprint: sno3i7m
blocked_by:
- 01M5G0WT0R042QBZS2WB44XR11
comments:
- id: 01M5GPT1GD50B7BPAFC7A5BGTG
  author: Steve Vine
  at: 2026-10-22T02:24:57.357172Z
  text: |-
    Done — merged in PR #1223.

    - **Add evidence** on Audit ▸ Evidence ▸ Register: upload a file or add a link, fill in its details and pick the core controls it supports. You land on its page.
    - On any piece of evidence's page, a manager sees **Also supports** and can link it to another control. Controls linked by hand are marked **Linked** and can be unlinked. The control it sits on can't be.
    - Unlinked controls stay listed under **Earlier links**: "No longer supports ASM.1 — linked by Sam on …, removed by Jo on …".
    - A control's **assessment card** gains **Linked from elsewhere**: evidence added in Audit, or a plan file, certificate or other record linked to this control. Each shows a download or open link, where it came from, and who linked it and when. An assessor can unlink it there; the evidence itself stays.
    - **Activity** says "linked firewall-review.pdf to NES.3" and "unlinked … from NES.3".
    - All of this needs Manage evidence. An archived company refuses it, and a switched-off control can't be linked.
    - Admin ▸ Files lists these files as "Audit evidence"; a company purge removes them with the company.
    - **Fix:** the Evidence register (COM-1205) failed for any evidence that recorded who added it, which is nearly all real evidence. Its tests had only used files without an uploader. Fixed here, before staging ever saw it, and a test now covers it.

    My calls (beyond the task):
    - **Where it belongs:** evidence added in the register belongs to the company. It shows as from "Audit ▸ Evidence" and defaults to type Other.
    - **What can be linked:** files, links and vendor certificates. Library documents can't, because they're tied to controls through the library.
    - **What's refused:** linking a control the evidence already supports because of where it sits ("that's where it was added"), and linking a control twice.
    - **No controls needed:** evidence can be added without picking any controls.
    - **On the assessment card:** an assessor can unlink there. Linking new controls needs Manage evidence, so I didn't add linking from the card.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1208 (chain order); uses the register (COM-1205).

**Chain:** on the chain — migration + API

## What people see

- **Add evidence** on the Register tab:
  - upload a file or add a link, with its facts (what it is, evidence type, period covered, valid until);
  - pick the core controls it supports, searching by number or name.
  - It then shows on each of those controls' assessments as evidence, the same as a file added there.
- **Also supports** on any piece of evidence's detail adds or removes core controls.
  - The control it was added to stays: an assessment's file always supports its own control, and a plan activity's file its activity's controls.
  - Trust centre documents and vendor certificates are linked the same way, for example the company's ISO 27001 certificate to the certification and management-review controls.
- The Supports list on the detail updates straight away, framework controls included.
- Each link and unlink is recorded in Activity with who and when. An unlinked control shows in the evidence's history ("No longer supports NES.3 — removed by …"), so it's never silently lost.
- Needs **Manage evidence**. An assessor can also add a file on the assessment card as today, and link it to more controls there.

## Notes (technical)

- `evidence_control_links`: evidence id (attachment or link), core control, company, added by/at, removed by/at. Soft-unlink only; audited.
- Register-owned evidence (no parent record) is a new attachment owner type, `evidence`, scoped to the company.
- The register's "supports" = the source's implied controls ∪ the active links.

**Done when:** a file added in the register and linked to three controls appears on all three assessments and under all their framework controls; unlinking one leaves a record.