---
id: 01M7K60AFE63AJ9BS0WAAQBAPY
created: 2026-11-16T22:00:24.302883Z
updated: 2026-11-16T22:36:50.958225Z
type: task
title: 'A built-in check can be edited from its page: on/off, thresholds, its name and description, and its controls, per company'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1882
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: backlog
---
From Steve's testing of round 2 (staging 43d03f09). Steve: "Built in checks are also not editable at the moment, can this be changed?"

**Today.** Under Evidence Collection ▸ Settings, a company can switch a built-in check on or off and change its thresholds. Nothing can be changed from the check's own page. Its name, description and controls are the same for every company and can't be changed at all.

*Amended 16 Nov:* on/off, thresholds and controls also live on the new **Built-in Checks** tab (COM-1885), and come off Settings. The check's Edit and that tab show and save the same values, using one controls editor.

**Behaviour** (assumptions decided here, not by Steve)
- **Edit** on a built-in check's page, for whoever can change the Built-in Checks tab. It covers:
  - **On / off.** Switching off asks first and closes the gap it raised.
  - **Thresholds.** These are the same values as the Built-in Checks tab.
  - **Raises its own gap** (once COM-1884 lands).
  - **Name and description, for this company.** "Reset to Compass's wording" brings back the original. Lists, the control's Evidence tab and Polaris all use the company's name.
  - **Its controls, for this company.** You can add or remove a control, with a reason. A check keeps at least one control. Each control added or removed is marked for its coverage to be confirmed (COM-1880). The check's results, and any gap it raises, follow its controls from then on. An open gap it raised on a removed control is closed with "CHK-n no longer evidences <control>: <reason>". "Reset to Compass's controls" is available too.
- **What it tests stays fixed.** It's written into Compass. Details says so in one line: "What this check tests is built into Compass; for a different test, collect the evidence and judge it with a workflow."
- **Recorded.** There's an Activity line on the check, and on any control added or removed, for each change, with the reason where one was given.
- **Polaris.** Polaris can explain these settings, but on/off and thresholds stay on screen. Polaris can propose a rename or a control change, which a person confirms in Edit.

**Done when**
- The behaviour above works on staging for a built-in check in Test Company. Renaming it shows the new name on Evidence Collection, the Built-in Checks tab, the control and the check page. Adding a control shows the check on that control's Evidence tab, marked to confirm.
- An amendment to ADR 0132 records that a built-in check's name, description and controls can be set per company, and that what it tests stays fixed.
- Tests cover:
  - each field;
  - reset;
  - the gap that closes when a control is removed;
  - refusing to remove the last control;
  - the to-confirm marks;
  - the Built-in Checks tab and Edit showing the same values.

**Where** (for the builder): pages/CheckDetailPage.tsx, checks/checks.ts, core/checks (directory, engine, `_declared`), the per-company check settings (ADR 0132 §7), core/collection/coverage.py. This builds on COM-1880 (coverage on the control), goes with COM-1881 (the page layout), and shares its editor and saving with COM-1885 (the Built-in Checks tab).