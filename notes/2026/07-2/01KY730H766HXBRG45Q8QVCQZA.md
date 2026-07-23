---
id: 01KY730H766HXBRG45Q8QVCQZA
created: 2026-07-23T08:55:55.878381Z
updated: 2026-07-23T09:18:26.787065Z
type: task
title: 'Periodic update check: re-check on window focus, throttled to every 4 hours'
task_status: done
label: null
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 335
sprint: segj1dz
---
The updater (DEV-975) checks the channel once, 5 seconds after startup, plus the manual check in Settings → About. Notuvia is a tray app that can stay resident for weeks, so a startup-only check degrades into "never checks" for the normal usage pattern — 0.8.0 was only offered after a relaunch.

**Change:** keep the startup check, and also run the quiet check (`checkForUpdate({ manual: false })`) from the existing window `focus` handler in `Main.svelte` (the one that already triggers `requestSync`), throttled to at most once every 4 hours.

Notes:

* Focus-triggered beats a bare `setInterval`: the check fires when the user is actually present to see the banner, and the wiring point already exists.
* The existing behaviour makes repeated checks polite already — background failures are silent, and a version declined with "Not now" stays quiet until a newer one ships.
* Production-only, same as the startup check (`import.meta.env.DEV` guard) — a dev binary can't install an update.
* Track the last-check time in module state (or localStorage) in `updater.svelte.ts` so the throttle survives the component and applies across both check paths.

---

Linear DEV-988 · Enhancements · created 2026-07-15 · done 2026-07-18