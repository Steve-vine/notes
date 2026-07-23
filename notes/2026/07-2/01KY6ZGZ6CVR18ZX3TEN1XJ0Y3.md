---
id: 01KY6ZGZ6CVR18ZX3TEN1XJ0Y3
created: 2026-07-23T07:55:00.172796Z
updated: 2026-07-23T07:55:08.984962Z
type: task
title: Orphan attachment cleanup
label: brief
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 100
comments:
- id: 01KY6ZH7SR4F2MSDWCC6SWBDD5
  author: Steve Vine
  at: 2026-07-23T07:55:08.984522Z
  text: |-
    Steve Vine · 2026-06-26:

    Built and opened [PR #90](https://github.com/Steve-vine/notula/pull/90). Branch `steve/dev-652-orphan-attachment-cleanup`.

    **Checklist:**
    - ✅ **On reference removal:** saving a note prunes attachment files its body no longer references (immediate on-save reconciliation, per ADR 0015).
    - ✅ **Guarded:** the kept set is derived from the *just-saved* content, so a still-referenced file is never deleted; in-flight `.tmp` siblings are skipped.
    - ✅ **Rides auto-commit:** prune runs in `update_note` before `git_touch`, so deletions commit with the edit (ADR 0013).
    - ✅ **Swept case:** not needed — the per-note folder makes immediate reconciliation sufficient (ADR 0015 said no swept GC). Empty folders are removed.
    - ⚠️ **On note delete:** see below.

    **Scope finding (the important one):** the *"remove the folder when the note is deleted"* checklist item **has no call site** — the app has **no note-deletion path** (no in-app delete action/command/UI anywhere). So I:
    - Delivered the on-save reconciliation fully (the achievable Done-when bullet).
    - Added a tested `attachment::remove_all()` helper, ready for the cascade.
    - Filed **DEV-657** (follow-up, parent of this) to wire the cascade once a note-delete path exists.
    - **Did not** cascade from the watcher on sync/external deletes — deleting binaries from a background reconcile risks data loss on transient states; that's part of DEV-657's design.

    Flagging this because it narrows the brief — if you'd rather I **build a note-deletion feature** here (delete action + index removal + git rm + the cascade), that's a bigger piece and I'd want your nod first. My call was to ship the safe, complete half now and not invent a deletion feature inside an attachment-cleanup brief.

    **CI:** `cargo fmt --check`, `clippy -D warnings`, `cargo test` (129 ✓, +5), `npm run check` (0 errors), `npm test` (69 ✓), `npm run build` — green.

    Moving to In Review for your merge call. This is the last M12 brief — merging it (with DEV-657 tracked separately) closes the milestone.
---
Stop the `attachments/` tree from accumulating dead files. Implements the orphan/lifecycle policy defined in ADR 0015.

## Checklist

- [ ] **On note delete:** remove the note's `attachments/<note-id>/` folder along with the note file
- [ ] **On reference removal:** when a note is saved and an attachment is no longer referenced anywhere in its body, remove the now-orphaned file from its folder (per ADR 0015's chosen policy — immediate vs. swept)
- [ ] Removals go through the same atomic + git-touch path so cleanup is committed by the auto-commit debounce (ADR 0013), and a sync-deleted note's attachments reconcile correctly
- [ ] Guard against deleting a file still referenced by the body (re-scan references before unlinking)
- [ ] Decide & document behaviour for the swept case (e.g. a maintenance pass that GCs folders with no surviving note) if ADR 0015 calls for it

## Done when

- [ ] Deleting a note removes its attachment folder; removing an embed from a note's body and saving removes the orphaned file
- [ ] CI green (verbatim CI commands run locally), PR opened

---

Linear DEV-652 · M12 - Attachments · created 2026-06-25 · done 2026-06-26