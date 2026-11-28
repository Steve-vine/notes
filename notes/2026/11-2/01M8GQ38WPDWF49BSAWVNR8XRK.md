---
id: 01M8GQ38WPDWF49BSAWVNR8XRK
created: 2026-11-28T09:17:05.302924Z
updated: 2026-11-28T09:17:05.302924Z
type: task
title: 'Python scripts: written in Automation ▸ Scripts, run in the sealed-off runner, inputs as variables and outputs from a returned dict'
priority: medium
assignee: steve
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2232
---
**On the chain.** After the sealed-off runner and the Web/API action integration. Built after PowerShell; the same shape.

## What people see
- **A new script's language can be Python**, with Python highlighting.
- **Inputs** arrive as named values the script reads (`inputs["SignInName"]`), never pasted into its text. Hidden ones are never stored.
- **The integration** is handed over ready to use. For a Web/API integration, an HTTP session already signed in to its address (`api.post("/zones/{zone}/dns_records", json=…)`); for a SQL Server database, a connection.
- **Outputs**: the script returns a dict, read back by the declared output names.
- **A script fails** when it raises. The run shows the error's message, never a long traceback, and the full detail is kept on the run.
- A small fixed set of libraries is available (HTTP and SQL Server). Nothing can be installed by a script.
- Everything else works as for SQL and PowerShell.

**Done when:** on staging, a Python script against a test Web/API integration creates a record from an input and hands back its ID; a failing one shows its error; and a workflow passes the ID to the next step.