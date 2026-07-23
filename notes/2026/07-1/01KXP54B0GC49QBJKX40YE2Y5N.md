---
id: 01KXP54B0GC49QBJKX40YE2Y5N
created: 2026-07-16T19:05:52.400362232Z
updated: 2026-07-23T13:54:51.415873Z
type: task
title: Issue input panel — chat + pre-baked actions
project: 01KX671DATY39VW6GWK3M2T3DN
number: 98
sprint: s0v93ii
blocked_by:
- 01KXP52NRFDXD3Z6KTDXGFS1G0
- 01KXP53VCVSZB7F8AN2KSXYAX1
assignee: steve
priority: high
task_status: done
---
The bottom panel of the redesigned screen (ISE-88): free chat with the issue AI **plus** a row of pre-baked action buttons directly above the input box.

**Composer:**
- A `Textarea` (autosize, Enter-to-send) that streams a turn into the issue conversation (ISE-91) via the adapted `streamTurn`/`useAssistTurn` stack; Send/Stop toggle with an `AbortController` (mirror `AssistPage.tsx:211-228`). The live turn renders in the timeline feed (ISE-97).

**Pre-baked action buttons (row above the input):**
- **Analyse** (ISE-94), **Diagnose**, **Propose remediation**, **Acknowledge**, **Resolve**, **Dismiss** — wired to their endpoints: existing `POST .../diagnose`, `POST .../propose-remediation`, `PATCH .../status`, and the new `POST .../analyse`.
- Operator-gating and disabled states as today: buttons operator-only (`hasRole(user,'operator')`); Diagnose disabled without `issue.system_id`; lifecycle buttons follow the client `VALID_TRANSITIONS` mirror (`IssueDetailPage.tsx:21-26`). These triggers are the button half of the loop; the chat is the prompt half (ISE-93) — both land as timeline events.

Blocked by the streaming conversation (ISE-91) and the layout shell (ISE-96). Uses the new analyse endpoint (ISE-94). Label: feature.