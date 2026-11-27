---
id: 01M8EVWB720QQ5GJX27MZQHCJD
created: 2026-11-27T16:02:12.322671Z
updated: 2026-11-27T16:04:33.40337Z
type: task
title: 'Automation ▸ Scripts: a script with declared inputs and outputs, written in SQL against an action integration, versioned (draft, then publish), with Preview of exactly what would be sent'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2195
sprint: snt3b17
blocked_by:
- 01M8EVV51Z35MTQ7HGQ0RNPKQ7
- 01M8EVVQZR7CA1XDQ6RZ0C9AB8
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain** (new tables and API). After COM-2193 (role) and COM-2194 (integrations). ADR 0185.

## What people see
- **Automation ▸ Scripts** is a new screen beside Workflows. It lists scripts with: language, the integration each runs against, published version, owner, which workflows use it, and its last run and outcome.
- **A script** has:
  - name, description and owner;
  - **language**: *SQL* this sprint (PowerShell and Python appear later, greyed out as "coming later" or not at all; decide in the PR);
  - **integration**: an action integration of a kind the language can use (SQL → a SQL Server database);
  - **inputs**: each has a name (`SignInName`), a label ("Sign-in name"), a type (text, whole number, decimal, true/false, date, date and time), whether it's required, whether it's *Sensitive* (COM-2196), and a description;
  - **outputs**: each has a name (`CrmUserId`), a label and a type;
  - **the script**: an editor with SQL highlighting.
- **How SQL uses inputs and outputs**, said on screen:
  - Inputs are named in the script as `@SignInName`, and Compass passes them **as values, never as text in the statement**, so an apostrophe or anything nasty in a name can't change what runs.
  - Outputs are read from **the first row of the last result**, by column name (`SELECT @@IDENTITY AS CrmUserId`).
  - A declared output missing from the result is an error.
  - An `@name` the script uses is caught when it's saved if it's neither a declared input nor a variable the script declares for itself (`DECLARE @Count int`).
  - The script runs in **one transaction**: it all happens or none of it does.
- **Versions**: the script is edited as a draft. **Publish** makes it the version workflows run, with a note ("Adds the department code"). Every published version is kept and can be compared with the one before. A workflow always runs the *published* version current when it runs. Unpublished changes never run.
- **Preview** (anyone who can see the script): fill in sample inputs and it shows **exactly what would be sent** (the statement, and each value with its type), **without connecting or running anything**. There's no automatic undo; that was ruled out as unworkable for real scripts.
- **Retire** a script: it stops being runnable, with workflows using it listed first, and is kept with its history. It can be restored.
- Only **Script Managers** can create, edit, publish and retire; everyone who can see Automation can read.
- Everything is in the activity log, including the full text of each published version.

## Notes (technical)
- Models: `Script`, `ScriptVersion` (immutable once published: text, inputs, outputs, integration id, language), draft held on the script.
- Validation on save: parse `@name` references (ignoring comments and string literals). Allow declared inputs, variables the script `DECLARE`s, and system ones (`@@IDENTITY`, `@@ROWCOUNT`). Anything else is refused, named.
- Language is an enum ready for `powershell` and `python`. Their runners must be sandboxed (ADR 0185); not this sprint.
- Screen conventions: page header, tabs (Script, Versions, Runs, Used by), FieldRow, SortableTh.
- Running (Run now, run history) is COM-2196.

**Done when:** on staging, a Script Manager creates a SQL script with two inputs and one output, Preview shows the statement and typed values without touching the database, publishing makes version 1, an edit after publishing leaves version 1 as the one that runs until published again, a script that uses an undeclared `@Department` can't be saved, and one that `DECLARE`s its own `@Count` can.