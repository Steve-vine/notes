---
id: 01M5CQ74BZWHT0AQSAG1SS7NEE
created: 2026-10-20T13:15:08.543604Z
updated: 2026-10-20T22:33:35.955264Z
type: task
title: The trust centre portal — a signed-in visitor sees the company's overview and its documents, grouped by category, and can read each in the browser or download it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1162
sprint: sq3fav7
blocked_by:
- 01M5CQ6K3F2F9N05BW2SASA25Q
comments:
- id: 01M5DQ5PEKRTB6QXYEQW7E5VAD
  author: Steve Vine
  at: 2026-10-20T22:33:35.955149Z
  text: |-
    Done — merged in PR #1170.

    - A signed-in visitor sees one page in the company's branding:
      - a header with the logo, title, their name and Sign out;
      - the intro and contact email;
      - Documents, grouped by category in the order the admins set;
      - a footer reading "Access until 19 Nov 2026".
    - Each document shows its name, description and, for evidence, "Issued … · Valid until …". View opens the PDF in a new tab; Download saves it under the document's name.
    - Restricted documents the visitor was given carry a "Restricted" marker. Restricted documents they weren't given don't appear at all.
    - If a document is hidden, expires or is removed while the page is open, clicking it says "This document is no longer available." and it drops off the list.
    - Guessing another document's address gets the same "no longer available" answer whatever the reason, including another company's document. Without a signed-in visit, nothing is served at all.
    - It works on a phone: each document's buttons wrap under its name.

    Later tasks add to this page: badges, Security, FAQs, Subprocessors, Updates, the NDA and the watermark.

    My calls:
    - View fetches the document first, then opens it, so a document that has gone shows the message rather than an error in a blank tab.
    - If a document's file can't be produced (after access has been checked), the visitor sees "This document can't be opened just now".
assignee: steve
label:
- feature
priority: high
task_status: active
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