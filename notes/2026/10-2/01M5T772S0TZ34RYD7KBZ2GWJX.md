---
id: 01M5T772S0TZ34RYD7KBZ2GWJX
created: 2026-10-25T19:04:51.74427Z
updated: 2026-10-26T08:03:46.783444Z
type: task
title: 'DDQ: a "Trust Centre" card — who it was shared with, when each person opened and downloaded it, and "Stop sharing"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1324
sprint: snfoon1
blocked_by:
- 01M5T76PG2ZC4945EJYA6BZY7H
comments:
- id: 01M5TXWGC9TSPZD5GVNK4BGRVE
  author: Steve Vine
  at: 2026-10-26T01:41:02.473193Z
  text: |-
    Done — merged to main (PR #1340).

    - **A sent DDQ shared through the Trust Centre gets a Trust Centre card.** For each person it shows:
      - their name (linked to their visitor page, for people who can see the Trust Centre) and email;
      - when it was shared, and by whom;
      - their access now: "Access until …", Expired or Revoked;
      - "Last opened …" or "Not opened yet";
      - what they downloaded, for example "Downloaded the completed questionnaire, 3 evidence files — …".
    - **Stop sharing** needs Manage visitors too. It takes the DDQ out of that person's area at once, and they aren't told. An optional reason goes in History, and the row stays as "Stopped …".
    - **Share with someone else** opens the send window.
    - **A DDQ sent in through the portal** says "Received through the Trust Centre from Jane Smith on …" in its header, linked to the visitor.
    - **The register** tags DDQs received or shared through the Trust Centre, and has a **Came from** filter: Trust Centre, or Logged here.
    - **A visitor's page** has a Questionnaires panel: what they sent in, and what was shared with them, each by DDQ number (linked for people who can view DDQs).
    - **Trust Centre ▸ Activity** has a **Questionnaires** switch, and the CSV export follows it.

    My calls:
    - **Stopped shares stay on the card**, greyed, as the record of who it went to.
    - **"Came from" is a filter and a tag, not a column.**
    - **The Questionnaires panel is hidden** for a visitor with no questionnaires.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
## Behaviour

- **A DDQ shared through the Trust Centre gets a "Trust Centre" card.** It lists each person it was shared with:
  - name, email, when it was shared, and by whom;
  - their access ("until 24 Nov", "Expired", "Revoked");
  - **last opened** and **downloaded** ("Completed questionnaire, 3 evidence files — 26 Oct 10:14"). "Not opened yet" until they do.
- **Stop sharing** (one person): the DDQ disappears from that person's area at once, silently. They stay a visitor of the trust centre. A reason is optional, and it's kept in History.
- **Share with someone else** opens the COM-1322 window.
- **A DDQ that came in through the portal** shows "Received through the Trust Centre from Jane Smith on 25 Oct" in its header. It links to the visitor in Trust Centre ▸ Visitors if the person can see the trust centre.
- **The DDQ register:**
  - shows a small "Trust Centre" tag beside the requester on DDQs received or shared that way;
  - gets a **Came from** filter: Trust Centre, or Logged here.
- **Trust Centre ▸ Visitors:** a visitor's row gets a **Questionnaires** list: what they sent in, and what was shared with them, each with its DDQ number linking to the DDQ (for people who can view DDQs).
- **Trust Centre ▸ Activity:** the questionnaire events (sent in, file added, downloads) appear with the rest, filterable as "Questionnaires".

## My calls (awaiting Steve)

- Stop sharing is per person and silent, matching Revoke.
- The register shows a tag and a filter, not a column.
- Someone who can see the trust centre but not DDQs sees the DDQ number without a link.

## Notes

- **On the chain:** API `GET /api/v1/ddqs/{id}/trust-centre` (shares with access state and event summary), `POST …/trust-centre/{share}/stop`, the register filter param, and the visitor detail gaining questionnaires. Regenerate schema.d.ts.
- New tables follow the screen conventions (SortableTh or a no-sort comment). Run the full vitest suite.
- The event summary is read from `trust_centre_events` by DDQ id (COM-1323).
