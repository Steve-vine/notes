---
id: 01M8GQ38WPDWF49BSAWVNR8XRK
created: 2026-11-28T09:17:05.302924Z
updated: 2026-11-28T14:22:01.516075Z
type: task
title: 'Python scripts: generators that run in Compass, turning inputs into values for later steps, or into a SQL command or API call Compass sends'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2232
sprint: s09wwd3
comments:
- id: 01M8H8HM9C1ED40T08EGZ31M7J
  author: Steve Vine
  at: 2026-11-28T14:22:01.515927Z
  text: |-
    Done in PR #2240 (merged). A script's language can be Python, with Python highlighting. Inputs arrive as inputs["DisplayName"], and the script ends with return {...}. It returns values, or {sql, parameters} for a SQL Server database, or {method, path, query, body} for a web service. A syntax error is refused when you save, with its line. It runs sealed off like PowerShell: standard library only, no network, no credentials. Everything else is shared with PowerShell (COM-2231): the rule check, sending, Try it, the run showing exactly what was sent, and hidden values as "(hidden)".
    Tested end to end through the API against a real SQL Server: "Ada Lovelace" became "ada.lovelace" and the INSERT was built. Try it (Script Managers only) showed the command, with the hidden value hidden, and nothing was sent: the table stayed empty. Run now sent it, handed back the new ID, and the run showed the command as sent.
assignee: steve
label:
- feature
priority: medium
task_status: active
---
**On the chain.** After PowerShell (COM-2231), with the same shape. ADR COM-2225.

## What people see
- **A new script's language can be Python**, with Python highlighting.
- **Inputs** arrive as named values (`inputs["DisplayName"]`), never pasted into the text. Hidden ones are never stored.
- **The script works out what to send; it reaches nothing itself.** It returns either:
  - **values** (a dict keyed by the declared output names); or
  - **a request for Compass to send** to its integration:
    - a SQL command with parameters, for a Server ▸ SQL Server database (`{"sql": "INSERT … VALUES (@SignInName)", "parameters": {"SignInName": name}}`);
    - an API call, for a Web/API integration (`{"method": "POST", "path": f"/zones/{zone}/dns_records", "body": {...}}`).

    Compass sends it with the credential the script never sees, and reads the answer back as outputs.
- The example Steve gave: turn "Ada Lovelace" into "ada.lovelace" (or however the business forms user names) and build the SQL that creates her CRM account.
- **The run shows exactly what was sent**, then the answer and outputs. A raised error fails the run with its message; the full traceback is kept on the run, not shown first.
- A small fixed set of standard libraries is available (string handling, dates, JSON, regular expressions). Nothing can be installed, and nothing can reach the network.
- Preview, Try it, Run now, Retry, workflows, the run history, Actions and the Event log work as for PowerShell.

**Done when:** on staging, a Python script turns a display name into a sign-in name and builds the SQL to add it; Compass runs that against the test database and hands back the new ID; and the run shows the command exactly as sent.