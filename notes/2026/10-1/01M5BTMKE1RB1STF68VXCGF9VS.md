---
id: 01M5BTMKE1RB1STF68VXCGF9VS
created: 2026-10-20T04:55:41.249874Z
updated: 2026-10-20T05:26:03.247836Z
type: task
title: The retention log hides a restricted request's details from people who can't see it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1150
sprint: ss8348q
comments:
- id: 01M5BWC690A9JEE5C83AX86XM6
  author: Steve Vine
  at: 2026-10-20T05:26:02.784485Z
  text: |-
    Done — merged (PR #1143).

    - In Settings ▸ Retention, a restricted request's line in the retention log is now in full only for people named on that request. Everyone else sees the reference (not a link), the date and what happened ("Held", or "Cleared by the nightly retention run"); the rule reads "Restricted request", with no hold reason.
    - The same for a disclosure or request to disclose about a restricted request's person ("Restricted disclosure" / "Restricted request to disclose").
    - The log's CSV, and the Compliance tab's retention-log export, follow the same rule, so all three agree.
    - Through the assistant, restricted lines stay hidden altogether.

    My call, for you to confirm: someone who can see restricted requests but isn't named on a particular one still gets the shortened line — the log is evidence that goes to auditors, so it follows the stricter "named on it" rule the exports use.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Follow-up from sprint 79 (found while building COM-1147 part 2).

**What's wrong:** Settings ▸ Retention's log, and its CSV, show a restricted request's line in full — including the legal-hold reason (free text) — to anyone who can view the module. The same applies to disclosures and requests to disclose about a restricted request's person. The assistant already drops these lines; the screen doesn't.

**What it should do:** for someone not named on the restricted request, its line shows only the reference, the date and what happened (cleared or held), and reads "Restricted request"; the reason and rule text are blank. The same in the CSV. The Compliance tab's retention log export already does this (COM-1143's follow-up) — the screen and its CSV should match it.

**Done when:** a viewer not named on a restricted request sees no hold reason for it in the log or the CSV; someone named on it sees the full line.