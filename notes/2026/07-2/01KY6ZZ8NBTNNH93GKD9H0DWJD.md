---
id: 01KY6ZZ8NBTNNH93GKD9H0DWJD
created: 2026-07-23T08:02:48.619901Z
updated: 2026-07-23T09:17:54.785842Z
type: task
title: Flaky watcher self-write suppression tests intermittently fail
task_status: done
label: null
priority: medium
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 127
comments:
- id: 01KY6ZZEFZE9VM50WTN3J5Y9FE
  author: Steve Vine
  at: 2026-07-23T08:02:54.590611Z
  text: |-
    Steve Vine · 2026-07-07:

    **Planned work (Claude, 2026-07-07):** the flake's root cause is in the app, not just the tests — self-write suppression is *consume-on-match* (`self_writes.remove()` on the first matching event), and macOS FSEvents can deliver duplicate/late events for one write: the first consumes the entry, the second sees identical content with no entry and fires the "external change" callback. That intermittently fails the tests and, in the app, can raise a false changed-on-disk conflict on a dirty buffer.

    Fix: switch to **keep-on-match** — the recorded hash stays while events keep matching it (duplicates all suppress, whenever they land) and is dropped only when a non-matching (genuinely external) change arrives. Side effect is benign: an external write of byte-identical content is treated as a self-echo, which changes nothing user-visible (the index still reconciles). Tests become deterministic: the note test synchronises on the reconciled index instead of entry consumption, and the "nothing fired" assertions are sound at any event timing because a matching event can never fire.
- id: 01KY6ZZN59P8W6MA6RA52QG2ZW
  author: Steve Vine
  at: 2026-07-23T08:03:01.417243Z
  text: |-
    Steve Vine · 2026-07-07:

    **Build complete — PR [#208](https://github.com/Steve-vine/notuvia/pull/208)**, single-file change in `watcher.rs`.

    The flake was a real bug: suppression consumed the recorded hash on the first matching event, so a duplicate/late FSEvents delivery for the same write looked external — failing the tests ~1-in-3 and, in the app, firing a phantom `note-changed` that could raise a false conflict guard on a dirty buffer. Suppression is now keep-on-match via a shared `is_external` helper (note + taxonomies paths): duplicates all suppress whenever they land; the entry drops only on a genuinely different change. Benign trade documented in-code: an external byte-identical rewrite also suppresses (nothing to reload; reconcile runs regardless).

    Tests reworked to be deterministic (sync on the reconciled index, not entry consumption) plus a direct unit test for the duplicate-event regression. **Watcher suite run 15× in a row: 0 failures** (was ~1-in-3). 223 backend tests pass, fmt/clippy clean.
sprint: sx9znt9
---
The watcher tests in `src-tauri/src/watcher.rs` that assert self-writes are suppressed (e.g. `external_taxonomy_edit_fires_callback_self_write_is_suppressed`, and the related `external_change_fires_callback_self_write_is_suppressed`) intermittently fail with `a self-write should not fire the ... callback` (left: 1, right: 0).

They're timing-sensitive: the test pre-records a self-write hash then writes the file, racing the debounced filesystem watcher. Observed failing ~1-in-3 runs locally, including in the `lefthook` pre-push hook — blocking pushes until retried (it passes on re-run).

**Impact:** wastes CI/pre-push cycles and erodes trust in the suite; a real regression here could be dismissed as "just the flaky test".

**Fix ideas:** make the assertion wait deterministically (poll with a timeout for the expected callback count rather than a single fixed sleep), or inject a synchronization point so the self-write hash is guaranteed registered before the fs event is processed.

Surfaced while working the UI Improvements milestone (DEV-709, PR #109).

---

Linear DEV-720 · Backlog · created 2026-06-29 · done 2026-07-07