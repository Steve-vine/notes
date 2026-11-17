---
id: 01M7K82NZYFP1CYZ3CY140PK1W
created: 2026-11-16T22:36:38.782839Z
updated: 2026-11-17T02:51:24.730359Z
type: task
title: Evidence Collection gets a Built-in Checks tab (switch on/off, thresholds, controls); Settings keeps only company-wide settings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1885
sprint: s7nqsy0
comments:
- id: 01M7KPN50RT45Y7PE5Q9G63BNR
  author: Steve Vine
  at: 2026-11-17T02:51:24.056818Z
  text: |-
    Done — PR #1884, merged 12ff0d02.
    Evidence Collection has a new tab, Built-in Checks, between All checks and Settings, for whoever can change Settings. Each built-in check has a row: ID, its name with what it tests underneath (linked to its page), its controls with Change, its thresholds (read-only — the tooltip says "Change it on the check's page" and the cell links there), its state, Raises its own gap, and On.
    Change opens the same controls editor as the check's Edit (COM-1882). Switching a check off, or its own gap off, asks first and says which open gap will close.
    The tab filters by On / Off and by state, kept in the address. Settings now holds only a check's gap, Collected evidence and Collection feeds.
    The Browser smoke opens the new tab for every test account that has it.
    Assumptions: the tab's count includes switched-off checks; the State filter shows only checks that are on.
    To check on staging: Test Company ▸ Evidence Collection ▸ Built-in Checks at desktop and phone width — switch one off and on, change a control, then see the change on the check's page, All checks and the control's Evidence tab; change a threshold on the check's page and see it on the tab.
assignee: steve
priority: medium
task_status: review
---
From Steve's testing of round 2 (staging 43d03f09). Steve:
- "Move the Thresholds for built-in checks to the checks screen and off the settings screen."
- "Move the built-in checks to a new tab (before settings) called Built-in Checks. In here they can be enabled or disabled."
- "It should be possible to change which control they're associated with on the Built-in Checks tab."
- *Amended 16 Nov:* "Thresholds should only be editable on Evidence Collection->All Checks->Check". A threshold is changed only on the check's own page (COM-1882 Edit). This tab shows thresholds read-only.

**Today.** Evidence Collection ▸ Settings holds a table of built-in checks (ID, check, controls, threshold, on), together with the company-wide settings: a check's gap, Collected evidence, and Collection feeds.

**Behaviour** (assumptions decided here, not by Steve)
- **A new tab, Built-in Checks**, between All checks and Settings: Overview · Review · All checks · **Built-in Checks** · Settings. It's for whoever can change Settings today. Everyone else doesn't see it, as with Settings.
- **The table**, one row per built-in check, with these columns:
  - **ID**, sortable, by ID ascending by default;
  - **Check**, the name (the company's own, once COM-1882 lands) with what it tests underneath, sortable, linked to the check's page;
  - **Controls**, linked;
  - **Thresholds**, read-only (e.g. "90 days"). Its tooltip says "Change it on the check's page", and the cell links there;
  - **State**, the passing/failing pill;
  - **Raises its own gap** (once COM-1884 lands);
  - **On**, a switch.
- **On / off** in the row. Switching off asks first and closes the gap it raised, as it does today.
- **Thresholds** come off the Settings tab and are shown here read-only. They are only changed in the check's Edit, on its page (Evidence Collection ▸ All checks ▸ the check; COM-1882).
- **Controls.** "Change" in the row opens the controls editor: add or remove, with a reason, keeping at least one. It's the same editor and behaviour as COM-1882:
  - per company;
  - each control added or removed is marked for its coverage to be confirmed (COM-1880);
  - an open gap on a removed control is closed with a note;
  - "Reset to Compass's controls" is available.
- **Settings** keeps only the company-wide settings: a check's gap (how long it has to be fixed), Collected evidence (hold threshold) and Collection feeds. The built-in checks table leaves it.
- **Filters.** The tab can be filtered by On / Off and by state, with the filters kept in the address like other lists.

**Done when**
- The behaviour above works on staging (Test Company) and at phone width.
- Settings no longer lists built-in checks or their thresholds, and the tab has no threshold editor.
- Changing a control or on/off on the tab shows straight away on the check's page, on Evidence Collection ▸ All checks and on the control's Evidence tab. A threshold changed on the check's page shows straight away on the tab.
- The screen-conventions test passes (sortable columns or no-sort markers). The page's tests are updated, and the Browser smoke covers the new tab for each test account.

**Where** (for the builder): pages/ChecksPage.tsx (tabs), checks/ChecksSettingsTab.tsx (the table and threshold editing move out; GapTarget, HoldThreshold and FeedHold stay), checks/checks.ts, the per-company check settings API, and app/e2e (the smoke's tab list). This shares its controls editor and saving with COM-1882, and builds on COM-1880 for the "to confirm" marks.