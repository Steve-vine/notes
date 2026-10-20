---
id: 01M5BTMKE1RB1STF68VXCGF9VS
created: 2026-10-20T04:55:41.249874Z
updated: 2026-10-20T04:55:43.954557Z
type: task
title: The retention log hides a restricted request's details from people who can't see it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1150
sprint: ss8348q
assignee: steve
label:
- bug
priority: high
task_status: active
---
Follow-up from sprint 79 (found while building COM-1147 part 2).

**What's wrong:** Settings ▸ Retention's log, and its CSV, show a restricted request's line in full — including the legal-hold reason (free text) — to anyone who can view the module. The same applies to disclosures and requests to disclose about a restricted request's person. The assistant already drops these lines; the screen doesn't.

**What it should do:** for someone not named on the restricted request, its line shows only the reference, the date and what happened (cleared or held), and reads "Restricted request"; the reason and rule text are blank. The same in the CSV. The Compliance tab's retention log export already does this (COM-1143's follow-up) — the screen and its CSV should match it.

**Done when:** a viewer not named on a restricted request sees no hold reason for it in the log or the CSV; someone named on it sees the full line.