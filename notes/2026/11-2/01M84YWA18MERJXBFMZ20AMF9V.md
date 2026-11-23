---
id: 01M84YWA18MERJXBFMZ20AMF9V
created: 2026-11-23T19:42:12.520743Z
updated: 2026-11-23T19:42:17.506543Z
type: task
title: A register provided to an audit keeps the controls it had on the provided date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2125
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Sprint "Registers - Phase 2". Found in the auditor portal check of COM-2095 on staging d8a915977 (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2095/26-control-removed-since-provided.png`.

## The problem
A register kept for INS.5 is provided to a request and the auditor sees INS.5. Someone then removes the control from the register in Compass. The auditor's view and downloaded PDF now read "Controls: None linked". What's provided is meant not to change (COM-2094, ADR 0167 §6), and COM-2095 says the auditor sees the register's controls as they stood on that date.

## What people see
- A provided register shows the auditor the controls it was kept for when it was provided, on screen and in the watermarked PDF, whatever happens to its controls afterwards.
- For a past as-at day, Compass holds no history of a register's control links, so it shows the controls linked at the moment of providing.
- Providing it again takes the controls as they are then.
- Inside Compass, the register's own page still shows its controls now.

## Done when
- Removing or adding a control after providing doesn't change what the auditor sees, on screen or in the PDF.
- Providing it again shows the current controls.
- Items provided before this fix show the controls linked when the fix is deployed, as nothing earlier is held. Registers phase 2 hasn't been released, so this affects staging only.

Probably on the chain: migration + API.