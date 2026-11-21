---
id: 01M7YCMZ9BFCQ6JVD4H3CYPJQ1
created: 2026-11-21T06:28:11.179934Z
updated: 2026-11-21T07:12:56.992359Z
type: task
title: 'User Portal: audit request owners and corrective-action owners add evidence through the Add evidence window, with a classification'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2049
sprint: s9hexqn
comments:
- id: 01M7YF6V7BKQMN180WW9WTRAMB
  author: Steve Vine
  at: 2026-11-21T07:12:53.995205Z
  text: |-
    Done and merged to main (PR #2043). No migration.

    What changes:
    - On the User Portal, an audit request's owner and a corrective action's owner add evidence through the Add evidence window, Add new tab only. Upload stays blocked until each piece has an evidence type and a classification. Dates start on the audit's period: its observation period, otherwise its planned dates.
    - Their old portal upload is gone, and so is what sat behind it.
    - "Pick from your evidence" stays as its own button beside Add evidence. It has no upload of its own, only their evidence and a search of it.
    - Who may add is unchanged: the request's owner, and for a corrective action, the finding's owner or the plan's owner.
    - Fixed on the way: a corrective action's owner without View audit was refused by the window ("not found"), including on the finding panel inside Compass.
    - A test now holds the portal to one file upload outside the window, the Report an incident form, so nothing else on the portal can add evidence without a classification.

    Calls for you to overturn:
    - "Pick from your evidence" stays, because owners can't see the register and it's their only way to reuse something they've already added.
    - "Add more information" on your own incident report still takes files that arrive Not classified. I treated it as part of the Report an incident exception.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found while building COM-2044 (2026-11-21). On the User Portal, an audit request's owner and a corrective action's owner still use the old Add evidence: upload a file, or pick from their own evidence. That upload doesn't ask for a classification, so it gets round ADR 0164's rule that a person classifies what they add. COM-2043 already moved the portal's schedule entry owner onto the window, with the Add new tab only.

**What changes**
- On the User Portal, an audit request's owner and a corrective action's owner add evidence through the same Add evidence window: Add new only, with the classification and evidence type required, and dates starting on the audit's period.
- Their old upload goes, and Compass refuses a portal upload without a classification.
- Their "pick from your own evidence" stays if it's still needed (owners can't read the register). If it stays, it's offered beside the button, not as a second upload.
- Who may add stays as today: the request's owner, and the corrective action's owner.

**Done when**
- A request owner and a corrective-action owner on the portal add evidence through the window and must classify it.
- Nothing on the portal can add the company's evidence without a classification, apart from the Report an incident form (ADR 0164).

On the chain: API change.