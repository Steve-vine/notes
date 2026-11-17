---
id: 01M7K60AFE63AJ9BS0WAAQBAPY
created: 2026-11-16T22:00:24.302883Z
updated: 2026-11-17T19:50:15.317205Z
type: task
title: 'A built-in check can be edited from its page: on/off, thresholds, its name and description, and its controls, per company'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1882
sprint: s7nqsy0
comments:
- id: 01M7KNSR4S3YPR0QVQD86GAFS8
  author: Steve Vine
  at: 2026-11-17T02:36:26.137426Z
  text: |-
    Done — PR #1883, merged cda2f21f.
    A built-in check's page (Evidence Collection ▸ All checks ▸ the check) now has Edit, for whoever can change check settings: switch it on or off (asks first and names the gap that closes); "Raises its own gap" (asks first when turned off); its thresholds — now changed only here (Settings shows them read-only, linked to the check's page); its name and description for this company, with "Reset to Compass's wording"; and its controls for this company — add or remove with a reason, keeping at least one, with "Reset to Compass's controls".
    A renamed check reads by its new name on All checks, the control's Evidence tab, the check page, search and Polaris. A control added or removed is marked To confirm for its coverage, and an open gap the check raised on a removed control closes with "CHB-n no longer evidences <control>: <reason>". The check runs at once, so its results follow its new controls. Details says "What this check tests is built into Compass; for a different test, collect the evidence and judge it with a workflow." Each change is in the check's Changes, and a control's History shows a check added to or taken off it.
    The controls editor is one component, ready for the Built-in Checks tab (COM-1885).
    Assumptions: a gap closed by removing a control is set Cancelled, with the reason on its thread.
    To check on staging: in Test Company rename a built-in check and add a control to it — the name should show everywhere and the check should appear on the new control's Evidence tab marked To confirm.
- id: 01M7MJDSR6MJNPQ7S5DS88WZ2W
  author: Steve Vine
  at: 2026-11-17T10:56:43.269775Z
  text: |-
    Pre-UAT on staging 44d15b9a — Failed (two small defects: workflows don't follow a control added to a built-in check, and workflow wording keeps Compass's name after a rename)
    Done in E2E Test Company on CHB-6 "Top admin roles are few" (ACC.3), as E2E Admin A.
    - Edit on the check's page: Passed. Edit CHB-6 has On for this company, Thresholds (At most, "1 to 50 people; Compass's default is 4.", Save thresholds), Raises its own gap, Name and description for this company (with "Reset to Compass's wording"), and Controls for this company (with Why and "Reset to Compass's controls (ACC.3)"). Details says "What this check tests is built into Compass; for a different test, collect the evidence and judge it with a workflow."
    - On/off: Passed. Switching off asked "Switch CHB-6 off? It stops running for this company until it's switched back on. Its open gap GAP-144 will be closed.", and GAP-144 closed ("Closed by Compass: check switched off"). Switched back on, it ran again.
    - Thresholds, changed only here: Passed. I set 4→5 and it passed at once on Run now, then back to 4. The Built-in Checks tab shows "4 people" with no editor. Settings has no check thresholds left (only gap due days, capture holds and feed holds).
    - Rename shows everywhere: Passed for the check page, All checks, Built-in Checks, ACC.3's Evidence tab and Polaris's posture_get_check. Failed for workflows: while renamed, the builder's check picker still listed "CHB-6 · Top admin roles are few", and so did WFL-11's sentence ("When evidence is collected by CHB-6 · Top admin roles are few", also through Polaris's posture_get_workflow). Reset to Compass's wording worked.
    - Controls: Passed for adding and removing. I added VUM.8 with a reason, and CHB-6 appeared on VUM.8's Evidence tab with VUM.8 TO CONFIRM ("CHB-6 added"); removing it gave "CHB-6 added; CHB-6 removed". When only ACC.3 is left there's no remove button, and the editor says "A check keeps at least one control." The own gap closes on a removed control: Passed. With INS.10 (an assessed control) added, CHB-6 raised GAP-145 there. Removing INS.10 set it Cancelled with "CHB-6 no longer evidences INS.10: E2E pre-UAT COM-1882 removing INS.10 after the test". Changes lists "CHB-6 now evidences …" and "no longer evidences …" with the reasons.
    - Results follow its controls: Failed for workflows. With INS.10 added, CHB-6's card and its own gap were on INS.10, but a workflow judging its evidence only ever saw ACC.3. WFL-11 ("raise a gap on the control when Non-compliant") and Compass's WFL-1 both reported only "Leave ACC.3: it isn't assessed", and never touched INS.10, though INS.10 is assessed (Partial). After I assessed ACC.3, WFL-11 raised GAP-143 on ACC.3 only. Polaris's test of a draft also lists the piece's controls as ["ACC.3"].
    - ADR 0132 amendment: Passed. "Amendment (2026-11-17, COM-1882): a built-in check, as each company has it" is on main.
    Observations: saving only the name records "named it …; gave it back Compass's description" though the description wasn't touched. Threshold changes and the own-gap switch appear in the Activity log only as "updated check setting check …", and not in the check's Changes.
    Put back: Compass's name, ACC.3 only, threshold 4, on, raises its own gap. ACC.3 and VUM.8 coverage confirmed. I did assess ACC.3 as Partial so workflow gaps could be raised (see COM-1884); that assessment stays.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1882/
- id: 01M7MPSQA3FT8KK75HW4KXVKPG
  author: Steve Vine
  at: 2026-11-17T12:13:08.29138Z
  text: 'Re-check on 00a2eb16 after COM-1896: Passed. As E2E Admin A, I added INS.10 to CHB-6 with WFL-11 enabled for the test. WFL-11 ran at once and raised gaps on both ACC.3 and INS.10. On the next pass and fail of the check, WFL-11 and Compass''s WFL-1 each closed and then raised their gaps on both controls (WFL-1: GAP-155 on ACC.3, GAP-156 on INS.10). The on-screen Test and Polaris''s test list both controls. Taking INS.10 off cancelled the workflow gaps there ("CHB-6 no longer evidences INS.10: …"), and later runs acted on ACC.3 only. After a rename, the builder''s check picker, WFL-11''s sentences and Polaris''s posture_get_workflow all said "CHB-6 · E2E pre-UAT COM-1896 few top admins". Put back: Compass''s name, ACC.3 only, WFL-11 disabled. Screenshots: ~/compass-uat/s7nqsy0/COM-1896/'
assignee: steve
priority: medium
task_status: done
---
From Steve's testing of round 2 (staging 43d03f09). Steve: "Built in checks are also not editable at the moment, can this be changed?"

**Today.** Under Evidence Collection ▸ Settings, a company can switch a built-in check on or off and change its thresholds. Nothing can be changed from the check's own page. Its name, description and controls are the same for every company and can't be changed at all.

*Amended 16 Nov:*
- On/off and controls also live on the new **Built-in Checks** tab (COM-1885), and come off Settings. The check's Edit and that tab show and save the same values, using one controls editor.
- Steve: "Thresholds should only be editable on Evidence Collection->All Checks->Check". **This Edit is the only place a threshold is changed.** The Built-in Checks tab and the control's Evidence tab show thresholds read-only and link here.

**Behaviour** (assumptions decided here, not by Steve)
- **Edit** on a built-in check's page (Evidence Collection ▸ All checks ▸ the check), for whoever can change the Built-in Checks tab. It covers:
  - **On / off.** Switching off asks first and closes the gap it raised.
  - **Thresholds.** These can be changed only here, and are recorded in Activity as today.
  - **Raises its own gap** (once COM-1884 lands).
  - **Name and description, for this company.** "Reset to Compass's wording" brings back the original. Lists, the control's Evidence tab and Polaris all use the company's name.
  - **Its controls, for this company.** You can add or remove a control, with a reason. A check keeps at least one control. Each control added or removed is marked for its coverage to be confirmed (COM-1880). The check's results, and any gap it raises, follow its controls from then on. An open gap it raised on a removed control is closed with "CHK-n no longer evidences <control>: <reason>". "Reset to Compass's controls" is available too.
- **What it tests stays fixed.** It's written into Compass. Details says so in one line: "What this check tests is built into Compass; for a different test, collect the evidence and judge it with a workflow."
- **Recorded.** There's an Activity line on the check, and on any control added or removed, for each change, with the reason where one was given.
- **Polaris.** Polaris can explain these settings, but on/off and thresholds stay on screen. Polaris can propose a rename or a control change, which a person confirms in Edit.

**Done when**
- The behaviour above works on staging for a built-in check in Test Company. Renaming it shows the new name on Evidence Collection, the Built-in Checks tab, the control and the check page. Adding a control shows the check on that control's Evidence tab, marked to confirm.
- No other screen can change a threshold.
- An amendment to ADR 0132 records that a built-in check's name, description and controls can be set per company, that its thresholds are changed on its own page, and that what it tests stays fixed.
- Tests cover:
  - each field;
  - reset;
  - the gap that closes when a control is removed;
  - refusing to remove the last control;
  - the to-confirm marks;
  - the Built-in Checks tab and Edit showing the same values;
  - the tab having no threshold editor.

**Where** (for the builder): pages/CheckDetailPage.tsx, checks/checks.ts, core/checks (directory, engine, `_declared`), the per-company check settings (ADR 0132 §7), core/collection/coverage.py. This builds on COM-1880 (coverage on the control), goes with COM-1881 (the page layout), and shares its controls editor and saving with COM-1885 (the Built-in Checks tab).