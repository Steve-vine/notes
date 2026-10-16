---
id: 01M52DBQ05GNPCGC0PT7SWQV2X
created: 2026-10-16T13:10:28.61308Z
updated: 2026-10-16T20:53:57.024939Z
type: task
title: The assistant can work the Validation tab — validate an expedited change, and adopt or flag for reversal a change made outside Compass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1018
sprint: scj9zdp
blocked_by:
- 01M52DAS19ZQPD2KKQS434CH2G
comments:
- id: 01M530AJF2A5NXD8NMW47XJ012
  author: Steve Vine
  at: 2026-10-16T18:41:54.1463Z
  text: |-
    Done — merged to main (PR #1010); goes to staging with the rest of the sprint.

    The assistant can now list expedited changes waiting to be validated and the unrequested changes (waiting, decided, or the screen's "recorded" section), validate an expedited change (refused on your own request, as on screen), adopt unrequested changes with a reason, and flag them for reversal linked to the request that puts them back (named by its ACR reference).

    My calls:
    - Adopt and flag take several changes at once, by number or by words ("adopt the two Helpdesk additions"). If any of them is already decided, nothing is saved.
    - "Recorded changes" on the screen means changes on groups no role maps — not the adopted or flagged ones — so the assistant keeps "decided" and "recorded" apart.
    - A directory role given straight to a person can be flagged without a corrective request; the answer says what someone must do in the Entra admin centre.

    Worth knowing (as the product behaves today, not changed):
    - On screen, the Decide button for unrequested changes needs "validate expedited", but the server checks "review unrequested". The assistant follows the server, so someone with only "validate expedited" sees the button but is refused. Probably a small screen fix — say if you want a task.
    - Once validated, a request's status pill still reads "Executed"; the assistant also says validated.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1016.

## What people can ask of it

- **Read (for a named company):**
  - **expedited changes** that have gone through and are waiting for a second person to validate them;
  - **unrequested changes**: access that changed in the directory without a Compass request, with who changed it and when;
  - **recorded changes**: what has been adopted or flagged already.
- **Write (whatever the person's role allows on screen):**
  - **validate** an expedited change. As on screen, you can't validate one you raised.
  - **adopt** an unrequested change, with the reason it stands;
  - **flag it for reversal**, linked to the request that puts it back. The assistant can raise that request through COM-1016 in the same conversation.
- **Example:** "What changed in the directory this week without a request? Adopt the two Helpdesk additions as approved by the service desk lead, and flag the rest for reversal."

## Notes (technical)

- Wraps `unrequested_changes.py`: list, adopt, and flag-reversal (`access.review_unrequested`). Also wraps `access_requests.py` validate (`access.validate_expedited`). The expedited list is the requests list filtered to awaiting validation.
- Validate is not destructive: the change already happened, and validating records the second person. Adopt and flag are writes. Flag-reversal needs the corrective request's reference, resolved through `find_access_request`.
- New module `tools/access_validation.py`.
- Tests: the requester is refused when validating their own request; the tools are hidden without the grants; an adoption is recorded via assistant.

**Done when:** on staging, the assistant lists unrequested changes and adopts one with a reason, and the Validation tab shows it as recorded, via assistant.