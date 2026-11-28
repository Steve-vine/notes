---
id: 01M8GW2EVJQT5G0J57Q3JGXYAW
created: 2026-11-28T10:44:01.522958Z
updated: 2026-11-28T14:29:39.772254Z
type: task
title: 'Scripts read a document''s named list: a List input for PowerShell and Python, and a single lookup from a list to fill any script''s input'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2236
sprint: s09wwd3
comments:
- id: 01M8H8ZK8B0WSTK8G8XKEQBQK6
  author: Steve Vine
  at: 2026-11-28T14:29:39.210847Z
  text: |-
    Done in PR #2244 (merged). Scripts can now use a document's named lists (the tables marked as lists in Content):
    - **List input** (PowerShell and Python): a new input type. The script gets the whole list: every row, each with its reference and columns. The input is filled from the latest published version of whichever document and list a workflow or Run now chooses (a picker shows each published document's lists). Under the ADR, the list's values count as the script's own text when checking what it would send, so a table or column name looked up in the list may appear in the generated SQL.
    - **Lookup** (any script, including SQL): a new source for a single input's value in a workflow's Run script mapping. Choose the document and list, the column to match, what to match it against (a trigger value or an earlier step's output), and the column to take. For example, find the row whose Department is the joiner's department and take its "CRM role". If nothing matches, the run fails, saying what it looked for.
    - Each run records the document, list and version it used, so it can be shown what a run read.
    Checked in tests against a real database: a list read in full, a lookup that found its row, one that didn't, and a list value allowed in the SQL a Python script generated.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**On the chain.** After the Scripting phase 2 ADR (COM-2225) and PowerShell (COM-2231). Raised by Steve on 28 Nov 2026: refer to a lookup table kept in Content from a script.

## What people see
**1. A List input (PowerShell and Python)**
- A script can declare an input of type **List**.
- Where the script is used (a workflow's Run script step, or Run now), the person chooses **a document and one of its named lists**, from the lists Content already has (a table marked as a list).
- Compass passes the list's rows **from the document's latest published version**:
  - Python gets a list of rows, each with its columns by name;
  - PowerShell gets an array of objects.
- The run records which document, list and **version** it used, so its outcome can always be explained later.
- Publishing a new version of the document changes what the next run gets; the script doesn't change. An unpublished draft is never read.
- Example: a department mapping table in a policy (Department · Team table · Role code); Python reads it to decide which team table and code apply to a new starter.

**2. A lookup as a value source (any script, SQL included)**
- In a workflow's Run script step, an input can be filled from **a document's list**: choose the document and list, the column to match on (e.g. Department), what to match it with (a trigger value or an earlier step's output), and the column to take (e.g. Team).
- The script just receives the one value, as a parameter for a SQL script.
- No matching row fails the step with the reason ("Department 'Marketing' isn't in the list Department mapping, Access Policy v4"). Test shows the value it would take.

**3. Generated SQL**
- Values from a List input the script declared count as the script's own text under the generated-SQL rule (COM-2225 §3). A looked-up table or column name can appear in the command, because it can't be a parameter. Other values still go as parameters.

- Polaris can say which lists a script reads, and which version a run used.

**Done when:** on staging, a Python script with a List input reads a mapping list from a published test document and builds the command for the right team table; publishing a new version changes the next run; and an SQL script's input filled by a lookup gets the matched value, with a missing row failing with its reason.