---
id: 01M5CQ8Y09SMCBJ5D55MKQ3HSJ
created: 2026-10-20T13:16:07.561664Z
updated: 2026-10-21T01:58:05.878242Z
type: task
title: A Content tab where admins write the security overview (sections like Encryption and Access control) and FAQs, shown to visitors on the portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1167
sprint: sq3fav7
blocked_by:
- 01M5CQ74BZWHT0AQSAG1SS7NEE
comments:
- id: 01M5E2W4SPW0H0BV3CZZYVX25Y
  author: Steve Vine
  at: 2026-10-21T01:58:05.877987Z
  text: |-
    Done — merged in two parts: #1172 and #1178.

    - **Trust Centre ▸ Content** has Security overview, FAQs and Preview. Subprocessors and Updates sit alongside them from their own tasks.
    - Security overview sections have a title and short text, with bold, lists and links. FAQs have a question, an answer and an optional group.
    - Each item is Shown, Hidden or Not written. Nothing can be shown until it's written.
    - **Add the standard sections** adds the ten usual headings, from Data encryption to Privacy, empty and hidden, ready to fill in.
    - Preview shows exactly what a visitor will see.
    - Visitors see **Security** (each shown section as a card, in order) and **FAQs** (grouped; click a question to open its answer) below the documents. Hidden or unwritten items never appear, and a part with nothing in it doesn't appear at all.
    - Anyone who can see the trust centre can read the Content tab. Only those who can manage the trust centre can change it. Every change is in the audit log.

    My calls:
    - Items are put in order with up/down buttons rather than drag and drop: simpler to use with a keyboard or on a phone.
    - The overview is only what admins write. It never pulls in control status from Compass.
    - The formatting is deliberately safe: no raw HTML, and links that could run code are dropped.
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1162. Subprocessors and Updates join this tab in their own tasks.

## What people see

**In the module, Content tab** (needs Manage the trust centre to change):

- **Security overview**: sections, each with a title and a short body (simple formatting: bold, lists, links), in an order admins drag. Compass offers a starting set, every one empty and unshown until written: Data encryption, Access control, Network security, Application security, Business continuity, Incident response, Vendor management, People security, Physical security, Privacy.
- **FAQs**: question and answer pairs, ordered, each shown or hidden. Optionally grouped (e.g. "Hosting", "Data").
- **Preview**: as the visitor sees it.

**On the portal:** a **Security** section with the overview sections as cards, and an **FAQs** section with expandable questions. A section with nothing shown doesn't appear.

The overview is written text only. It never shows control status from assessments, so the portal can't reveal an open gap.

## Notes (technical)

- `trust_centre_sections` and `trust_centre_faqs` (company, title/question, body Markdown, order, shown). Audited.
- Render Markdown safely on the portal (the same sanitiser the app uses for content; no raw HTML).

**Done when:** an Admin writes two overview sections and three FAQs, and a visitor on staging sees them in order; hidden ones don't appear.