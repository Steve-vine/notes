---
id: 01KY6YMRQJ6NV002QT9X6TBH91
created: 2026-07-23T07:39:36.050017Z
updated: 2026-07-23T09:17:53.163095Z
type: task
title: Hot-reload taxonomies.yaml on external change (watcher)
label:
- follow_up
assignee: steve
number: 44
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sdge8g4
---
Deferred from DEV-548. The app-driven CRUD path reloads the registry in-process, but a **hand edit / sync / git pull** of `taxonomies.yaml` isn't picked up until restart — the watcher only watches `notes/`, and the registry lives in `VaultRuntime` (backend), unreachable from the watcher thread.

**Checklist**

- [ ] Watch `taxonomies.yaml` (extend the DEV-508 watcher to the vault root / the file).
- [ ] On an external change (not a self-write — the hash is already recorded under the `"taxonomies.yaml"` key in DEV-548), reload the registry and refresh pickers/browse — e.g. emit a `taxonomies-changed` event + a `reload_taxonomies` command the frontend calls, or reload in the backend directly.

**Done when:** editing `taxonomies.yaml` by hand updates the app's taxonomy pickers/browse without a restart. Builds on DEV-534 (self-write guard) + DEV-548.

---

Linear DEV-553 · M6 — Taxonomy · created 2026-06-21 · done 2026-06-21