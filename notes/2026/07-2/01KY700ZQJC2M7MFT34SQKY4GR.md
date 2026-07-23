---
id: 01KY700ZQJC2M7MFT34SQKY4GR
created: 2026-07-23T08:03:45.010237Z
updated: 2026-07-23T09:08:57.851381Z
type: task
title: Rename user-facing identity & build artifact names
label: chore
assignee: steve
number: 130
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Rename all **display-only** occurrences of Notula → Notuvia. Zero migration risk — these are strings users see and build-artifact names, not identifiers that locate data.

## Changes

* `src-tauri/tauri.conf.json` — `productName: "Notula"` → `"Notuvia"`; window `title: "Notula"` → `"Notuvia"`. (Bundle `identifier` is **not** here — see the bundle-id migration issue.)
* `package.json` — `"name": "notula"` → `"notuvia"`.
* `src/app.html` — `<title>Notula</title>` → `<title>Notuvia</title>`. (The `notula:theme` localStorage key is **not** here — see the localStorage migration issue.)
* `src/lib/FirstRun.svelte` — `<h1>Welcome to Notula</h1>`.
* `src/lib/Settings.svelte` — "Choose an existing Notula vault…" copy.
* `.github/workflows/ci.yml` — artifact `name: notula-macos` → `notuvia-macos`.

`productName` also drives the macOS `.app`/`.dmg` artifact name, so the packaging output renames automatically.

## Done when

* App window title, first-run welcome, and settings copy all read "Notuvia".
* `npm run build` / packaging produces Notuvia-named artifacts; CI artifact renamed.

---

Linear DEV-735 · Rebrand · created 2026-06-30 · done 2026-06-30