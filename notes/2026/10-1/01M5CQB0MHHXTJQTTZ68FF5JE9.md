---
id: 01M5CQB0MHHXTJQTTZ68FF5JE9
created: 2026-10-20T13:17:15.793565Z
updated: 2026-10-21T04:04:04.835712Z
type: task
title: The assistant can work the Trust Centre — invite, extend and revoke visitors, decide requests, manage documents and content, and read activity, as the person and the same as on screen, but never upload a file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1172
sprint: sq3fav7
blocked_by:
- 01M5CQ7F20KK70EYHMC347FWKN
- 01M5CQ7VP2AB3QZTZBBTDY2PYK
- 01M5CQ89NJHJJWJ8YX5E5ZE6JC
- 01M5CQ8MTZHBAG1FARTRQ0AEV5
- 01M5CQ9D6NBMD5MGHMGS9VSQ7Q
- 01M5CQ9QZF5Q28KG02T232Z3Z1
- 01M5CQAJYCN5K4A2PS1EG2XWTB
comments:
- id: 01M5EA2P2K35H8QMJXH86AGR4D
  author: Steve Vine
  at: 2026-10-21T04:04:00.210898Z
  text: |-
    Done — merged in two parts: #1185 and #1187.

    - The assistant can now run the Trust Centre with 45 tools:
      - settings, including the NDA wording and the public page;
      - documents: share library content, change who can see them, edit details and order, remove;
      - visitors: invite (with documents), resend, extend, revoke, change their documents;
      - requests: approve (including new-link requests) and decline;
      - security overview sections, FAQs, subprocessors (from the suggestions) and updates (post, edit, hide, email).
    - It can also read each visitor's NDA standing and the wording they accepted, the badges and the certificates behind them, the Activity list, the 30-day summary, and who has read a document.
    - It can only do what the person asking could do on screen, and the audit log shows the change was made "via the assistant".
    - Any tool that emails someone outside the company says so. Emailing an update first replies "This will go to N people" and only sends once the person confirms.

    My calls:
    - The assistant never uploads or replaces a file. Documents are uploaded on screen.
    - It never opens the visitor portal and never hands out a sign-in link.
    - It doesn't return the network address or browser on activity or NDA records, because the screens don't show them either. It also doesn't change the logo.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Last: builds on every other task in the sprint.

## What people see

Someone using an AI assistant connected to Compass can ask it to:

- list and read the company's trust centre: settings, documents, visitors, requests, content and activity;
- **invite** a visitor (sends the email), **resend**, **extend**, **revoke**, and change a visitor's restricted documents;
- **approve or decline** a request (approving sends the invite);
- add a library document, change a document's tier, description, order or shown flag, and change an uploaded document's dates;
- write and order security overview sections, FAQs and subprocessors; post an update (and email it, after saying how many people it will reach);
- change Settings, including the NDA wording.

It does each only if the person could do it on screen, with the same rules, and the activity log shows the person "via the assistant".

**It can't:** upload or replace a file (a certificate or report has to be added on screen), or download a watermarked copy as if it were a visitor.

## Notes (technical)

- A `trust_centre` tool module in the assistant, auto-discovered like the others (ADR 0109; follow 0112/0113 and the `*_common` lookups pattern). Lookups by name/email as well as id.
- Tools call the same core functions as the API routes, so permissions and audit are shared. Mark sending tools (invite, resend, approve, decline, email an update) as acting outward in their descriptions.
- Update the assistant's tool count/catalogue tests.

**Done when:** from a connected assistant on staging, an Admin can invite a visitor, approve a request and post an update, and a person without Manage trust centre visitors is refused the invite tool.