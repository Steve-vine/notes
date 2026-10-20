---
id: 01M5CQB0MHHXTJQTTZ68FF5JE9
created: 2026-10-20T13:17:15.793565Z
updated: 2026-10-20T21:37:57.008987Z
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
assignee: steve
label:
- feature
priority: medium
task_status: active
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