---
id: 01M5T75ASA5Q04YVFSBVFD2J8Y
created: 2026-10-25T19:03:54.410233Z
updated: 2026-10-25T23:32:26.174974Z
type: task
title: 'Trust Centre: the public "ask for access" form gets an "I have a questionnaire to send" tick — shown on the request, and the invite tells them where to send it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1321
sprint: snfoon1
blocked_by:
- 01M5T7550AJYJWMQJR4RQF87BV
comments:
- id: 01M5TPGZS506B8CQ0X129AMF14
  author: Steve Vine
  at: 2026-10-25T23:32:24.99763Z
  text: |-
    Done — merged to main (PR #1335).

    - While Questionnaires through the Trust Centre is on, the public "ask for access" form has a tick: **"I have a security questionnaire to send you"**.
    - The request in Trust Centre ▸ Requests, its to-do and the "request waiting" email all say **"Has a questionnaire to send"**. The approve window mentions it too.
    - **Approving it** invites them as usual, with one extra line in the invitation: "Once you've signed in, you can send us your questionnaire under Questionnaires."
    - Nothing is uploaded on the public page. The tick changes nothing about how a request is decided, and the page's answers stay identical whatever is sent.
    - Polaris's request list shows it.

    My calls:
    - **The public page tells the browser whether to show the tick.** That's the only new fact it gives away, and the tick is visible anyway.
    - **A tick sent while questionnaires are off is ignored.** The answer is the same as for any request.
    - **A second request from the same person that joins a waiting one carries the tick across.**
    - **The extra line goes only in a first invitation**, never in a resend or a new link.
assignee: steve
label:
- feature
priority: low
task_status: review
---
## Why

Steve chose that only signed-in visitors can send questionnaires (COM-1316). A prospect who hasn't been invited asks for access first. This tick tells the person deciding that the prospect wants to send a questionnaire, so it isn't a surprise.

## Behaviour

- The public request page shows the tick **"I have a security questionnaire to send you"** only while Questionnaires are switched on (COM-1318).
- **The request** in Trust Centre ▸ Requests, and its to-do, show "Has a questionnaire to send".
- **Approving it** invites them as usual. The invitation email gets one extra line: "Once you've signed in, you can send us your questionnaire under Questionnaires."
- The tick never changes how the request is decided, and nothing is uploaded on the public page.

## My calls (awaiting Steve)

- The tick only appears while Questionnaires are on.
- The invite email line is the only follow-up. There's no reminder if they never send it.

## Notes

- **On the chain:** migration `trust_centre_requests.has_questionnaire` (bool, default false) and the request schemas (portal and internal). The public route keeps its identical-response rule (ADR 0120 §11).
- Assistant: `trust_centre_list_requests` shows it.
