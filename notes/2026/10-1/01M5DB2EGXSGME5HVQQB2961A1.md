---
id: 01M5DB2EGXSGME5HVQQB2961A1
created: 2026-10-20T19:02:06.621281Z
updated: 2026-10-21T20:16:50.755697Z
type: task
title: 'Log a request, Log a disclosure and Log a request to disclose open in the access request window: numbered sections, a summary beside them, buttons always in view'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1181
sprint: ss8348q
blocked_by:
- 01M5DAFG3YR20T97VTBQQ571J8
comments:
- id: 01M5F4T3TACT1P87R5KTF4CR35
  author: Steve Vine
  at: 2026-10-21T11:51:10.922738Z
  text: |-
    Done — PR #1200, merged 21 Oct 12:44 BST.

    - Log a request, Log a disclosure and Log a request to disclose now open in the same window as an access request. The title and the line under it stay at the top. Cancel and Save stay in the bottom bar, with any refusal message beside them. Only the middle scrolls.
    - Each part is a numbered box. A part that only sometimes applies takes a number only when it's shown (Acting for them, Forwarded by a customer, Restricted, Basis and approval, Incident, the customer's details), so the numbers never skip.
    - A summary on the right says what will be logged. It stays in view while you scroll, and drops underneath in a narrow window.
    - A request's summary shows the deadline Compass will actually give it, worked out by the server: "Due 20 Nov, 09:00 GMT · UK GDPR · 1 calendar month", or "Starts when identity is confirmed". While details are missing it says "Due date once the law and what they're asking for are set".
    - A disclosure's summary says whether it was authorised, who received it, about whom and the kinds of data. An authorised one shows its basis and "Approved by …" or "Needs approval". An unauthorised one shows its incident, or a reminder to link it to one.
    - A request to disclose's summary covers who asks, about whom, what they ask for, the grounds and reference, received and Respond by with the days left, whether it's a customer's data and whether the customer was told, and that someone other than the logger decides it.
    - Escape closes an open dropdown first, then the window.
    - Edit DSR-n, Correct DIS-n, Edit RTD-n and Record the disclosure use the same window. A correction's reason is the last section.
    - Every field, rule and error message is unchanged.

    My calls:
    - New sections where a long part split naturally: a disclosure gets "Files" (when logging) and "The correction" (when correcting). A request to disclose gets "The customer" and "Owner and files".
    - When a rule would start counting from confirmed identity, the request summary adds: "If ID is asked for, it counts from when identity is confirmed."
    - Editing a request previews its deadline with that request's own pauses and extension, matching what Save does.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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