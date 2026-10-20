---
id: 01M5B0H0TVZX8KPNYATV68HDZ8
created: 2026-10-19T21:19:20.923997Z
updated: 2026-10-20T00:43:06.120669Z
type: task
title: Letters — standard templates for every step (acknowledgement, ID or clarification needed, extension, response, refusal, recipient notification, complaint), editable per company, filled in from the request, copied or downloaded by the handler and marked sent
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1140
sprint: ss8348q
blocked_by:
- 01M5B0GF6H4CN109GC59RMKQB0
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 79, Data Privacy (ADR in COM-1129). Steve decided **the handler sends, and Compass records**. Compass fills the letter in, the handler sends it from the privacy mailbox, and marks it sent. Compass never emails the person.

## The templates (Settings ▸ Letters)

Shipped as shared standard templates, written in plain English. Each company can override the wording of any of them, and **Reset to standard** removes the override.

1. **Acknowledgement**: we've got your request, the reference, what happens next, the due date.
2. **Identity check needed**: what we need and why; the clock starts when we have it (where the law says).
3. **Clarification needed**: what we need to know; the clock is paused (UK GDPR).
4. **Extension**: the new date and the reason (within the first deadline).
5. **Response: access**: the data is enclosed or sent separately, plus the supplementary information: purposes, categories, recipients, retention, source, automated decisions, transfers, and the person's rights.
6. **Response: portability**.
7. **Response: correction, erasure, restriction or objection done**: what was done, and the recipients told (if asked for).
8. **Partly granted**: what was and wasn't done, and why.
9. **Refusal**: the reasons, the right to complain to the regulator (named from Settings ▸ Company per law) and the right to go to court.
10. **Recipient notification**: to a recipient, asking them to correct, erase or restrict.
11. **Complaint acknowledgement** (within 30 days, UK) and **Complaint outcome**.
12. **Forwarded to our customer**: to the person, saying we've passed it to the organisation responsible, and to the customer.

## Filling in

Templates have **fields** that Compass fills from the request: the person's name and address, our reference (DSR-12), received date, due date (and extended date), what was asked, decisions and reasons, fee, the systems and recipients lists, the accounting table, the company's privacy contact, the regulator, and today's date. The editor offers them from a picker. A field with no value shows as a highlighted gap.

## What people see on a request

- A **Letters** card. **Write a letter** picks a template, with the one that fits the current step suggested. Compass fills it in. The handler can edit the filled text for this request, then:
  - **Copy** (plain text, for the email body), or
  - **Download** (PDF in the house style, or Word).
- **Mark sent**: the date, how (email, post, in person) and to whom. The letter as sent is kept on the request, and goes on the timeline.
- The stage cards say when a letter is expected and not yet marked sent: "Extension letter not sent".

## Rules

- A letter marked sent can't be edited. A wrong letter is followed by a corrected one.
- A refusal or partly-granted letter can't be marked sent without the regulator field filled.

## Notes (technical)

- Templates as Tiptap content on the ADR 0110 renderer. **Per-record fields are new**: add a field node or a special block with a resolver per field. Mail rendering escapes values (`core/mail_render.py`), and so must this.
- Standard templates ship as seed content (the seed import runs every deploy). Company overrides in their own table.
- The letter as sent: the rendered text plus the template revision, insert-only.

**Done when:** a handler can write an acknowledgement filled with the request's details, edit it, copy or download it, and mark it sent; a company can override a template's wording and reset it.