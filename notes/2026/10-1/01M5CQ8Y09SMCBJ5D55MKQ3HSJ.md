---
id: 01M5CQ8Y09SMCBJ5D55MKQ3HSJ
created: 2026-10-20T13:16:07.561664Z
updated: 2026-10-20T13:16:07.561664Z
type: task
title: A Content tab where admins write the security overview (sections like Encryption and Access control) and FAQs, shown to visitors on the portal
assignee: steve
label: feature
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1167
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