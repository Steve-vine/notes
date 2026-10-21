---
id: 01M5G5V7TB0HYD0SWMQXXGRQ6M
created: 2026-10-21T21:28:30.795535Z
updated: 2026-10-21T21:28:30.795535Z
type: task
title: The assistant can work risk assessments as the person — list and read them, start one, work threats, record DPIA screenings and analyses, import threats and submit — but never approve one or accept a risk
assignee: steve
task_status: todo
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1242
---
Sprint 83, Risk Assessments (ADR in COM-1219). ADR 0109: the assistant works in Compass as the person, with their permissions. Built last.

**Chain:** independent (built last)

## What the assistant can do

- **Read:** list assessments (by kind, status, due), read one with its threats or sections, the overview (what's current, due, missing), the threat catalogue and the Risk to people scale.
- **Work:** start any kind; add, edit and remove threats (scores, controls, assets, decision, owner); fill in DPIA screening answers and DPIA sections; fill in PCI and AI impact analyses; import threats from a CSV the person gives it; submit for approval; withdraw.
- **Never:** approve or send back an assessment, approve a risk acceptance, or record the ICO's reply — these stay a person's act on screen, and the tools say so.
- Saves made by the assistant are marked "via the assistant" in History, as for risks today.

## Notes (technical)

- `assistant/tools/risk_assessments.py`, auto-discovered; lookups in a `risk_assessments_common.py`; tool count test updated.

**Done when:** asked "start this year's risk assessment for Moneypenny from last year's", the assistant creates the draft with the threats carried forward; asked to approve it, it explains a person must.