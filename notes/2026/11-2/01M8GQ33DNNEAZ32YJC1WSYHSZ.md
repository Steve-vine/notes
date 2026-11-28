---
id: 01M8GQ33DNNEAZ32YJC1WSYHSZ
created: 2026-11-28T09:16:59.701926Z
updated: 2026-11-28T09:49:14.328115Z
type: task
title: 'PowerShell scripts: generators that run in Compass, turning inputs into values for later steps, or into a SQL command or API call Compass sends'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2231
sprint: s09wwd3
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain.** After the sealed-off runner (COM-2230) and the Web/API action integration (COM-2227). ADR COM-2225.

## What people see
- **A new script's language can be PowerShell**, with PowerShell highlighting.
- **Inputs** arrive as PowerShell variables (`$DisplayName`), set before the script runs, never pasted into its text. Hidden inputs come the same way and are never stored.
- **The script works out what to send; it reaches nothing itself.** It hands back either:
  - **values**, by the declared output names (e.g. `@{ SignInName = ($DisplayName -replace ' ', '.').ToLower() }`), for later steps such as a SQL script's inputs; or
  - **a request for Compass to send** to the script's integration:
    - **for a Server ▸ SQL Server database:** a SQL command and its parameters (`@{ Sql = 'INSERT INTO dbo.Users (SignInName) VALUES (@SignInName)'; Parameters = @{ SignInName = $name } }`);
    - **for a Web/API integration:** an API call (`@{ Method = 'POST'; Path = "/zones/$Zone/dns_records"; Body = @{ … } }`).

    Compass sends it with the integration's credential, which the script never sees. It reads the answer back as the declared outputs (a SQL command's last row, or the API answer's fields by path).
- **The run shows what was sent:** the generated command or call exactly, values hidden where an input was hidden, then the answer and the outputs. A generated SQL command that pastes a value into its text, instead of passing it as a parameter, is refused (the exact rule is in the ADR).
- **Preview** runs nothing: it shows the script and the values it would be given. **Try it** runs the generator alone, without sending anything, and shows what it would send.
- A script fails when it throws or writes an error; the run shows the message.
- Everything else works as for SQL: draft and publish, Run now, Retry, workflows, the run history, Actions, and the Event log.

**Done when:** on staging, a PowerShell script turns a display name into a sign-in name and builds the SQL to add it; Compass runs that against the test database and hands back the new ID; the run shows the command exactly as sent; and Try it shows it without sending.