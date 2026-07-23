---
id: 01KY6YJ3PMY3W2TQHDV279AHS9
created: 2026-07-23T07:38:08.980287Z
updated: 2026-07-23T11:00:29.260829Z
type: task
title: ADR — in-app taxonomy management & taxonomies.yaml writes
number: 38
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sdge8g4
---
Record the decision that the app may **write** user taxonomies to `taxonomies.yaml` (and hot-reload), which ADR 0009 didn't cover — it kept *system* taxonomies app-owned and had the app only **read** the user file.

**Decision to record (agreed):**

* Editing a user taxonomy in the app **rewrites** `taxonomies.yaml` **as canonical YAML**, containing **only user-defined taxonomies** (system stay code-owned, ADR 0009). An app write may not preserve hand-added comments/formatting; hand-editing still works on load.
* After a write (or an external change to the file), the **registry hot-reloads and the index reindexes** so applicable-taxonomy lists and browse stay live (today the registry loads once at startup).
* The write is atomic (temp + rename, like notes/ADR 0004). Value objects keep ADR 0005's shape (`id`, `label`, `order`, `colour?`, `is_done?`).

**Refines** ADR 0009 (append-only — system ownership unchanged; this adds user-taxonomy write/reload). No change to how notes reference values.

**Done when:** the ADR is written (Date/Status/Context/Decision/Consequences) and merged. Gates the M6 implementation briefs.

---

Linear DEV-547 · M6 — Taxonomy · created 2026-06-21 · done 2026-06-21