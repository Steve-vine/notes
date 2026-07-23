---
id: 01KY6YM7DJZMN68KFZJVPF5NZM
created: 2026-07-23T07:39:18.322668Z
updated: 2026-07-23T11:04:51.763622Z
type: task
title: Surface taxonomies.yaml validation in-app
comments:
- id: 01KY6YMF78TMSP22RPXNB0PAFQ
  author: Steve Vine
  at: 2026-07-23T07:39:26.312357Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/41 — In Review.

    The loader's warnings (malformed/duplicate/system/bad-scope) are now kept on the runtime and exposed via a `taxonomy_warnings` command; the Taxonomies settings section shows a warning banner listing each skipped entry, refreshing on every reload. 50 cargo tests (new bad-scope warning test), 47 vitest, `npm run check` clean, `clippy -D warnings`, `npm run tauri build`.

    Holding for your sign-off + CI. Last M6 item after this is DEV-553 (hot-reload taxonomies.yaml on external hand-edit).
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 43
sprint: sdge8g4
---
The loader (DEV-483) already collects warnings for a malformed/duplicate/system-overriding `taxonomies.yaml`, but they only go to stderr. Surface them so a hand-edit mistake is visible.

**Checklist**

- [ ] Expose the registry load warnings to the frontend (a command / startup signal).
- [ ] Show them non-intrusively in the app (e.g. a banner in the Taxonomies settings section), with the offending entry/index.
- [ ] Re-validate + refresh on reload (after an edit or external file change).

**Done when:** a malformed/duplicate/system entry in `taxonomies.yaml` shows a clear, actionable warning in the app instead of silently being dropped. Builds on DEV-483; complements DEV-547/548.

---

Linear DEV-552 · M6 — Taxonomy · created 2026-06-21 · done 2026-06-21