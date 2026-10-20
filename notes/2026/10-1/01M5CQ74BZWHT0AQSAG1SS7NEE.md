---
id: 01M5CQ74BZWHT0AQSAG1SS7NEE
created: 2026-10-20T13:15:08.543604Z
updated: 2026-10-20T13:17:27.444093Z
type: task
title: The trust centre portal — a signed-in visitor sees the company's overview and its documents, grouped by category, and can read each in the browser or download it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1162
sprint: sq3fav7
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1159 and COM-1161. Later tasks add sections to this page.

## What people see

A single portal page in the company's branding:

- **Header**: logo, title, the visitor's name, Sign out.
- **Overview**: the intro text and the contact email. (Badges, security overview, subprocessors, FAQs and updates are added by their own tasks.)
- **Documents**, grouped by category in the admins' order. Each shows its name, description and, for evidence, issued and valid-until dates. **View** opens the PDF in the browser; **Download** saves it.
- Restricted documents the visitor has been given appear with a "Restricted" marker. Restricted documents they haven't been given don't appear at all. (The NDA task puts acceptance in front of them.)
- "Access until 19 Nov 2026" in the footer.

Nothing changes for a visitor while they're on the page if an admin hides a document or it expires: the next click says it's no longer available.

It works on a phone.

## Notes (technical)

- Session-authenticated routes under the trust centre router: overview, document list, document bytes. Every document route checks: same company, shown, not expired, and (if restricted) granted to this visitor. A document id from another company or visitor gets the same 404 as a missing one.
- Library documents served from the cached published-version PDF; uploads from the attachment store. `Content-Disposition` inline vs attachment.
- The frontend follows the screen conventions where they apply, styled with the company's branding rather than the internal app's chrome.

**Done when:** a signed-in visitor on staging sees the overview and their documents, can view and download them, and can't reach a restricted document they weren't given by guessing its address.