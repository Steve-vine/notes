---
id: 01M5DB2EGXSGME5HVQQB2961A1
created: 2026-10-20T19:02:06.621281Z
updated: 2026-10-21T10:14:25.543182Z
type: task
title: 'Log a request, Log a disclosure and Log a request to disclose open in the access request window: numbered sections, a summary beside them, buttons always in view'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1181
sprint: ss8348q
blocked_by:
- 01M5DAFG3YR20T97VTBQQ571J8
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve's request while smoke-testing sprint 79. The same treatment as COM-1177 gives the request page.

**What's wrong:** Log a request, Log a disclosure and Log a request to disclose are long single-column modals. Their parts ("What they are asking for", "The person", "About the request", "Who received it", "About whom", "From", "Dates"…) are plain headings. Save is at the bottom, below the fold, and nothing pulls together what's been entered. They look and behave differently from the joiner / mover / leaver windows in Access Control.

**What it should do:** all three open in the same window as an access request:
- **A title bar and a bottom bar that stay put.** The title ("Log a request" / "Log a disclosure" / "Log a request to disclose", or "Edit DSR-12" / "Correct DIS-4" / "Edit RTD-3") with one line under it saying what this is for. The buttons sit in the bottom bar, with any note or refusal message to the left of them. Only the middle scrolls.
- **Numbered sections on the left**, each part in its own box with its title inside next to its number. A part that only appears when it applies (Acting for them, Forwarded by a customer, Restricted; Basis and approval, Incident; the customer's details under "Our customer's data?") takes a number only when shown, so the numbers never have gaps.
- **A summary on the right** that stays in view as the left scrolls and drops underneath in a narrow window. It's a few lines that say what will be logged:
  - *Log a request:* the person (and representative or customer); what they're asking for; the law; the data entities; when it arrived and how; **the deadline it will get** ("Due 20 Nov · UK GDPR · 1 calendar month", or "Starts when identity is confirmed"); Restricted, if set.
  - *Log a disclosure:* authorised or unauthorised; who received it; about whom (a person, or a group and how many); the kinds of data; the basis, and approved by whom (or "Needs approval"); the incident it's linked to. For an unauthorised disclosure, a line saying it should be linked to an incident.
  - *Log a request to disclose:* who asks; about whom and what they ask for; the legal grounds given and their reference; received and respond by (with days left); whether it's a customer's data, and whether the customer was told (or why the law forbids it). Also a line that it needs approving by someone other than whoever logs it.
- **Escape** closes whatever is on top (a dropdown or a calendar) before it closes the window, as in the access request window.
- Editing a request or a request to disclose, and correcting a disclosure, use the same window. A correction's "Why it is being corrected" goes in the bottom bar's note area, or in a last section.

**Unchanged:** every field, its rules and its error messages. Error colours follow COM-1176.

**Behind it (technical):** reuse `RequestWindow`, `RequestSection`, `RequestFooter` and the summary pieces (`SummaryFact`, `SummaryBlock`, `SummaryNote`) from `access/requestWindow.tsx`, moved to a shared place alongside COM-1177. Don't build a second set. The request summary's deadline should be **the server's answer**, not worked out in the browser. That needs a small preview of the deadline from law, types and the received date (the deadline maths already exists). While it's loading, or if the details aren't complete, the line reads "Due date once the law and what they're asking for are set". The other two summaries only repeat what's on the form; no server call is needed.

**Done when:** all three modals open in the wide request window, with numbered boxed sections, a summary on the right that matches what's been entered, and Save / Cancel always visible. A request's summary shows the deadline the server will give it. Edit and correct use the same layout.