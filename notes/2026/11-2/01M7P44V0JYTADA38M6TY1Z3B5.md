---
id: 01M7P44V0JYTADA38M6TY1Z3B5
created: 2026-11-18T01:25:38.450189Z
updated: 2026-11-18T01:56:25.587888Z
type: task
title: A gap handed from "Gaps from evidence" to its check reads as the check's gap, and a custom check's Raise a gap switch has its own Activity line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1926
sprint: s7nqsy0
comments:
- id: 01M7P5X5KX9MQSDHTGEB5HV7ZK
  author: Steve Vine
  at: 2026-11-18T01:56:24.317283Z
  text: |-
    Done — PR #1898, merged 07b6af35.
    Each gap handed from "Gaps from evidence" to a check now reads as that check's own gap. Its title is "ACC.3: Top admin roles are few — Non-compliant". Its description starts "Raised by Compass check CHB-6: Top admin roles are few.", then says what made the evidence Non-compliant, then "Compass closes this gap when the check's evidence is Compliant." Its number, owner, target date, status and thread are unchanged, and the thread keeps the handover note. The gap's Activity has a line from Compass saying it was reworded.
    A gap left open for a person keeps its title. Its description now says why it was left open ("Left open for a person when the workflow “Gaps from evidence” was deleted: CHB-4's Raise a gap is off…"), not that the workflow closes it.
    This covers the gaps already handed over on staging. When the release reaches production, it runs straight after the handover, so production's handed gaps get these words in the same deploy.
    Switching a custom check's Raise a gap now shows in Activity as "switched Raise a gap off for CHC-2" (or "on"), the same words a built-in check gets.
    On a copy of staging's data (taken 01:34, 18 Nov), the before/after comparison held 35 and failed none. All 13 handed gaps now read as their check's: Demo GAP-127, 128, 129, 131 and 136; Test Company GAP-122, 132 to 135, 137 and 138; E2E GAP-160. None changed number, status, check, target date, owner or thread. GAP-160's title and description now match word for word the ones CHB-6 wrote on its own GAP-164.
    Assumptions: what made the evidence Non-compliant is read from where the evidence stands now, as the check does. A gap whose evidence isn't Non-compliant now just names the check. A title or description a person has rewritten since the handover keeps their words. Closed gaps that were handed over (such as GAP-160) are reworded too.
    To check on staging after deploy: in E2E Test Company, open GAP-160 and check its title and description read like GAP-164's. Admin ▸ Activity has the 13 "reworded GAP-n as CHB-n's own gap" lines. Switch CHC-2's Raise a gap off and on, and check Activity reads "switched Raise a gap off for CHC-2".
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found in the pre-UAT pass on staging 3171ce79 (sprint 117 round 4), 2026-11-18. Fix-forward for COM-1900 and COM-1897.

**What's wrong**
- The gaps COM-1900 handed from "Gaps from evidence" to their checks contradict themselves. GAP-160 (E2E Test Company, ACC.3) is headed "Raised by Compass check: CHB-6", but its description still says "Raised by workflow: Gaps from evidence … The workflow closes this gap when its evidence passes", and its title is still the workflow's ("ACC.3: Evidence is Non-compliant"). Only the thread comment explains the handover. Staging has 13 such gaps, and production will have its own when it's released.
- Switching a custom check's Raise a gap shows in Admin ▸ Activity only as "updated collected check … CHC-2", while a built-in check's line says "switched Raise a gap off for CHB-4".

**Done when**
- Each gap handed from the workflow to a check has the title and description that check gives its own gaps ("Raised by Compass check CHC-n / CHB-n: <name>", and who or what made the evidence Non-compliant, if that's known). Its number, owner, target date, status and thread are unchanged, and its thread keeps the handover note. This applies to gaps already handed over on staging (a new migration; the merged one isn't edited) and to any handed over when the release reaches production.
- A gap left open for a person (the check can't hold it) keeps a description saying why, not that the workflow closes it.
- Switching a custom check's Raise a gap on or off writes an Activity line in the same words as a built-in check's ("switched Raise a gap off for CHC-2").

On the chain (migration).