---
id: 01M84YWA18MERJXBFMZ20AMF9V
created: 2026-11-23T19:42:12.520743Z
updated: 2026-11-23T22:13:09.877287Z
type: task
title: A register provided to an audit keeps the controls it had on the provided date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2125
sprint: ssj8zkq
comments:
- id: 01M85391H7BY2R7F9CWX55BS7D
  author: Steve Vine
  at: 2026-11-23T20:59:04.10356Z
  text: |-
    Fixed and merged to main: PR #2109 (127babf98), with migration 0903_provided_register_controls, tested up, down and up on a populated database.

    What people see:
    - A provided register shows the auditor the controls it was kept for when it was provided, on screen, in the watermarked PDF and in Download all, whatever happens to its controls afterwards, including a control being renamed or retired.
    - A change to a register's controls alone now shows "The register has changed since" with Provide it again, which takes the controls as they are then. Providing it again on the same day is no longer refused as a duplicate.
    - Items already provided hold the controls linked when the migration ran.

    For Steve to decide:
    1. A past "as at" date can now list a control added after that date, because Compass keeps no history of a register's control links and this task says to show those linked at the moment of providing. Until now such a control was left out, and ADR 0167 §6 still says "before that date". Either accept this and the ADR gets amended, or it goes back to leaving those controls out.
    2. Not fixed: the auditor's copy of a register's filed review PDF (COM-2113) still reads the controls live, so removing a control later changes that copy. It probably needs its own task.

    Stored per provided item: only each control's reference and title, which come from the shared library and hold nothing about any company.

    Tested against real Postgres: changing controls afterwards changes nothing the auditor is given; a retired control stays; providing again takes the current ones; the migration; only reference and title are held. CI green.

    Not yet checked in a browser: the Auditor portal is off on staging again.
assignee: steve
label:
- bug
priority: medium
task_status: done
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