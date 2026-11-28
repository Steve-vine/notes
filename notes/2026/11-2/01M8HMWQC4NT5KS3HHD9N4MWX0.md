---
id: 01M8HMWQC4NT5KS3HHD9N4MWX0
created: 2026-11-28T17:57:48.036516Z
updated: 2026-11-28T17:57:57.225403Z
type: task
title: 'Scripting polish from pre-UAT: wording written for SQL on Web/API and generator screens, New script opening scrolled past its heading, selected text in dark mode, and two Event log details'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2243
sprint: s09wwd3
assignee: steve
label:
- bug
priority: low
task_status: active
---
**Small defects from the sprint 132 pre-UAT pass.** Independent: no migration, no API change.

1. **A Web/API action integration's page talks like a database.** Test connection "reads which login, database and server it reached", and its token is called a "password" ("password set…", "Deletes … and its password"). It should say what it does for a web service: "signs in and makes the test request", "token set…". (COM-2227)
2. **A PowerShell or Python script's inputs are shown as `@DisplayName`**, the SQL form, on the script's page. They should read `$DisplayName` for PowerShell and `inputs["DisplayName"]` for Python, as Preview already does. (COM-2231/2232)
3. **A SQL Server Collection integration's account form talks about keys:** "Key expires on", "Use a read-only key", and "Serves several companies: its repositories, containers or scans…". For a login it should say password, and the several-companies note should say what a database's parts are. (COM-2228)
4. **New script (and a Polaris draft opened from its link) opens scrolled about 100 pixels down**, hiding the page heading and the "Drafted by Polaris…" note. Pages without the script editor open at the top. (COM-2237/2195)
5. **In dark mode, selected text in the script editor is hard to read**: the selection colour is pale, and the light text on it is faint. (COM-2224)
6. **Event log:** a retry's Info entry says it was caused by "Compass" when a person pressed Retry; and a script run entry links to the script rather than to that run. (COM-2235)

**Done when:** on staging, each of the six reads or behaves as described above.