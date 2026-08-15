---
id: 01M023NEP80A1NJRPHRWHFH6E4
created: 2026-08-15T07:02:32.904849Z
updated: 2026-08-15T07:02:32.904849Z
type: task
title: A playbook shows its score but never the bar — say how far it is from running itself
label: improvement
task_status: backlog
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 723
tech: null
---
The Playbooks page already shows standing (`PlaybooksPage.tsx:132-161`) — `"3/4 worked (75%)"` for a remediation playbook, `"guided 6 · confirmed 4 (67%)"` for an advisory one, `"not yet applied"` at zero. What it never shows is **the bar those numbers are measured against**, or how far off it is.

So an operator can read the score and still not know whether the playbook is one run away from being trusted or twenty, or that it is quietly about to be demoted.

**Wanted:** the counts *and* the thresholds, stated as distance. *"Needs 1 more successful manual run before it can run automatically."*

**The thresholds already exist and are all invisible:**

| Bar | Value | Where |
|---|---|---|
| proven / `rubber-stamp` | `efficacy_total >= 2` and ratio `>= 0.66` | `playbooks.py:33-34` |
| desk auto-demotion | `>= 4` outcomes and ratio `< 0.5` retracts desk status | `playbook_envelope.py:33-34` |
| autonomy | stricter still — set by ISE-714 | not yet built |

**Scope**
- Show every counter the playbook has, named for what it means: successful runs, correctly dismissed (ISE-722's new counter), failed. Not one blended ratio — the whole point of ISE-722 is that these are different claims.
- State the next threshold as **distance**, not as a rule the reader has to apply: "1 more successful run to reach proven", "2 more failures would retract desk status". A reader should never have to hold `>= 2 and >= 0.66` in their head to work out where they stand.
- Show the demotion bar too, not just the promotion one. A playbook drifting toward auto-retraction is the more urgent fact and is currently silent until it happens.
- Where a playbook is *not eligible* for a rung, say why rather than showing a bar it can never reach — an advisory playbook is scored on a different counter entirely.
- Surface it wherever the playbook's standing already appears: the Playbooks list, the per-playbook desk section, and the incident's Playbooks section.

Depends on ISE-722 for the dismissal counter; the numbers it displays are meaningless for a no-op playbook until that lands. Related: ISE-714 sets the autonomy bar this must render.