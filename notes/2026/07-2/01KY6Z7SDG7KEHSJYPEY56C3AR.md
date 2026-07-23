---
id: 01KY6Z7SDG7KEHSJYPEY56C3AR
created: 2026-07-23T07:49:59.344468Z
updated: 2026-07-23T11:04:50.219468Z
type: task
title: Merge non-note (taxonomies.yaml) sync conflicts instead of keep-ours
task_status: done
imported_from: linear
assignee: steve
comments:
- id: 01KY6Z8024A59N4YFWKVBP1VSZ
  author: Steve Vine
  at: 2026-07-23T07:50:06.147747Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — PR opened: https://github.com/Steve-vine/notula/pull/79

    **What was done**
    - On a `taxonomies.yaml` sync conflict, keep ours and park the remote version as `taxonomies.conflict.yaml` for manual review — no longer silently dropped (mirrors the note conflict-copy model).
    - New `taxonomy_conflict` status flag, derived from the parked file's existence so it auto-clears when you reconcile and delete it. Surfaced as a note in Settings → Storage and turns the sync indicator red.

    **Approach chosen** — went with option 2 from the issue (keep-ours + visible sibling for manual reconciliation) over a semantic YAML 3-way merge: it's the lowest-risk way to satisfy the DoD ("no silent loss"), consistent with how note conflicts already work, and taxonomy-definition conflicts are rare. A true field-level merge could be a later enhancement if it ever becomes common.

    **Verification** — verbatim gates green: check (0 errors, 0 warnings), build, npm test (58), fmt, clippy, **cargo test 85** (+1 two-clone test: both diverge on `taxonomies.yaml` → puller keeps its version, remote lands in `taxonomies.conflict.yaml`). `npm run tauri build` left to CI.

    Moving to In Review — merge call is yours. **This was the last open issue in M10 — Sync.**
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 88
sprint: stkh502
---
Surfaced during DEV-615 (keep-both conflict resolution).

The keep-both resolution writes a sibling "conflict copy" only for conflicted **note** files (`notes/**/*.md`). A conflict on a **non-note** file — in practice `taxonomies.yaml` — is resolved **keep-ours** with no copy, so a remote change to that file is silently dropped on a true conflict.

This is rare (you'd have to edit taxonomy definitions on two machines between syncs) and contained, but it does mean `taxonomies.yaml` is the one path where sync can lose a remote change.

## Possible approaches

* 3-way merge `taxonomies.yaml` at the YAML level (it's a list of definitions keyed by `id`) and only flag truly conflicting entries.
* Or keep-ours but write the remote `taxonomies.yaml` to a visible `taxonomies.conflict.yaml` sibling for manual reconciliation (mirrors the note conflict-copy model).
* Validation/warnings already exist (DEV-552) and could surface the divergence.

## Definition of done

A same-file conflict on `taxonomies.yaml` no longer silently discards the remote change — it's either merged or preserved for review.

Ref: ADR 0013. Parent: DEV-615.

---

Linear DEV-631 · M10 — Sync · created 2026-06-25 · done 2026-06-25